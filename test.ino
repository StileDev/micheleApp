#include <WiFi.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include <DHT.h>

const char* WIFI_SSID     = "Redmi";
const char* WIFI_PASSWORD = "michele237";

const char* SERVER_URL   = "https://backend-irrigasmart.com";
const bool  SERVER_HTTPS = false;  

const int   PARCELLE_ID = 1;
const char* DEVICE_KEY  = "colle_ici_la_cle_copiee_depuis_l_app"; 


#define PIN_DHT            4
#define PIN_SOL_ANALOGIQUE 34
#define PIN_RELAIS_POMPE   26 

const bool RELAIS_ACTIF_A_HIGH = true;


const int SOL_VALEUR_SEC    = 3000;
const int SOL_VALEUR_HUMIDE = 1200;


const unsigned long SEND_INTERVAL_MS = 5000;
const unsigned long POLL_INTERVAL_MS = 2500;

const unsigned long DELAI_SECURITE_MS = 60000;

// ============ FIN CONFIGURATION ============

DHT dht(PIN_DHT, DHT11);

unsigned long dernierEnvoi = 0;
unsigned long dernierPolling = 0;
unsigned long dernierPollingReussi = 0;
unsigned long derniereTentativeWifi = 0;
bool pompeAllumee = false;

void commanderPompe(bool marche) {
  bool niveauHaut = marche ? RELAIS_ACTIF_A_HIGH : !RELAIS_ACTIF_A_HIGH;
  digitalWrite(PIN_RELAIS_POMPE, niveauHaut ? HIGH : LOW);
  pompeAllumee = marche;
}

void setup() {
  Serial.begin(115200);
  dht.begin();

  pinMode(PIN_RELAIS_POMPE, OUTPUT);
  commanderPompe(false);  // pompe éteinte au démarrage

  connecterWifi();
  dernierPollingReussi = millis();
}

void loop() {
  unsigned long maintenant = millis();

  // Arrêt de sécurité : serveur injoignable trop longtemps alors que la pompe tourne
  if (pompeAllumee && (maintenant - dernierPollingReussi > DELAI_SECURITE_MS)) {
    commanderPompe(false);
    Serial.println("SÉCURITÉ : serveur injoignable, pompe coupée.");
  }

  // Reconnexion WiFi (une tentative toutes les 10 s au maximum)
  if (WiFi.status() != WL_CONNECTED) {
    if (maintenant - derniereTentativeWifi > 10000) {
      derniereTentativeWifi = maintenant;
      connecterWifi();
    }
    return;
  }

  if (maintenant - dernierEnvoi >= SEND_INTERVAL_MS) {
    dernierEnvoi = maintenant;
    envoyerMesures();
  }

  if (maintenant - dernierPolling >= POLL_INTERVAL_MS) {
    dernierPolling = maintenant;
    verifierEtatPompe();
  }
}

// ---------- WiFi ----------

void connecterWifi() {
  Serial.print("Connexion au WiFi");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  unsigned long debut = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - debut < 15000) {
    delay(500);
    Serial.print(".");
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println(" connecté !");
    Serial.print("Adresse IP : ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println(" échec, nouvelle tentative plus tard.");
  }
}

// ---------- Capteurs ----------

float lireHumiditeSol() {
  int brute = analogRead(PIN_SOL_ANALOGIQUE);
  // Valeur ADC élevée = sec, basse = humide. On convertit en pourcentage
  // (100 % = très humide).
  float pourcentage = (float)(SOL_VALEUR_SEC - brute) * 100.0f / (float)(SOL_VALEUR_SEC - SOL_VALEUR_HUMIDE);
  return constrain(pourcentage, 0.0f, 100.0f);
}

// ---------- Requête HTTP (gère http et https) ----------

bool demarrerRequete(HTTPClient& http, WiFiClientSecure& clientSecure, const String& url) {
  http.setTimeout(5000);
  if (SERVER_HTTPS) {
    clientSecure.setInsecure();  // accepte le certificat sans le valider : pratique pour tester,
                                 // à remplacer par une vraie validation en production
    return http.begin(clientSecure, url);
  }
  return http.begin(url);
}

// ---------- Envoi des mesures (PATCH) ----------

void envoyerMesures() {
  float temperature = dht.readTemperature();
  float humiditeAir = dht.readHumidity();
  float humiditeSol = lireHumiditeSol();

  if (isnan(temperature) || isnan(humiditeAir)) {
    Serial.println("Erreur de lecture DHT22, mesure ignorée.");
    return;
  }

  StaticJsonDocument<200> doc;
  doc["temperature"]  = temperature;
  doc["humidite_air"] = humiditeAir;
  doc["humidite_sol"] = humiditeSol;

  String corps;
  serializeJson(doc, corps);

  String url = String(SERVER_URL) + "/irrigation/parcelles/" + String(PARCELLE_ID) + "/mesures/temps-reel/";

  HTTPClient http;
  WiFiClientSecure clientSecure;
  if (!demarrerRequete(http, clientSecure, url)) {
    Serial.println("Impossible de démarrer la requête PATCH.");
    return;
  }

  http.addHeader("Content-Type", "application/json");
  http.addHeader("X-Device-Key", DEVICE_KEY);

  int code = http.PATCH(corps);

  if (code == 200) {
    Serial.println("Mesure envoyée : temp=" + String(temperature) +
                   " air=" + String(humiditeAir) + " sol=" + String(humiditeSol));
  } else if (code == 401) {
    Serial.println("Clé d'appareil refusée : vérifie DEVICE_KEY et PARCELLE_ID.");
  } else {
    Serial.println("Erreur envoi mesure, code HTTP : " + String(code));
  }

  http.end();
}

// ---------- État de la pompe (GET, polling) ----------

void verifierEtatPompe() {
  String url = String(SERVER_URL) + "/irrigation/parcelles/" + String(PARCELLE_ID) + "/pompe/etat/";

  HTTPClient http;
  WiFiClientSecure clientSecure;
  if (!demarrerRequete(http, clientSecure, url)) {
    Serial.println("Impossible de démarrer la requête GET pompe/etat.");
    return;
  }

  http.addHeader("X-Device-Key", DEVICE_KEY);

  int code = http.GET();

  if (code == 200) {
    StaticJsonDocument<128> doc;
    DeserializationError erreur = deserializeJson(doc, http.getString());

    if (!erreur) {
      bool irrigationActive = doc["irrigation_actif"];
      commanderPompe(irrigationActive);
      dernierPollingReussi = millis();
      Serial.println(String("Pompe -> ") + (irrigationActive ? "MARCHE" : "ARRÊT"));
    } else {
      Serial.println("Erreur de lecture de la réponse JSON.");
    }
  } else if (code == 401) {
    Serial.println("Clé d'appareil refusée : vérifie DEVICE_KEY et PARCELLE_ID.");
  } else {
    Serial.println("Erreur polling pompe, code HTTP : " + String(code));
  }

  http.end();
}