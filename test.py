"""
Teste le flux complet du backend IrrigaSmart :
1. Connexion agriculteur (JWT) pour passer la parcelle en mode auto
2. Envoi de mesures comme le ferait l'ESP32 (juste X-Device-Key, pas de JWT)
3. Vérification que la pompe se déclenche/s'arrête automatiquement
   (polling de /pompe/etat/, "méthode A")

Nécessite : pip install requests
"""

import requests

BASE_URL = "http://10.108.171.167:8000"
EMAIL = "mbiegaingmk@gmail.com"
PASSWORD = "michele237"
PARCELLE_ID = 2
DEVICE_KEY = "b0d9e65c5bd5ef19a69d12f2e1aff506"


def se_connecter():
    resp = requests.post(f"{BASE_URL}/api/auth/login/", json={"email": EMAIL, "password": PASSWORD})
    resp.raise_for_status()
    return resp.json()["access"]


def passer_en_mode_auto(token):
    resp = requests.post(
        f"{BASE_URL}/irrigation/parcelles/{PARCELLE_ID}/irrigation/mode/",
        headers={"Authorization": f"Bearer {token}"},
        json={"mode": "auto"},
    )
    print("Mode ->", resp.status_code, resp.json())


def envoyer_mesure(humidite_sol=None, temperature=None, humidite_air=None):
    corps = {}
    if humidite_sol is not None:
        corps["humidite_sol"] = humidite_sol
    if temperature is not None:
        corps["temperature"] = temperature
    if humidite_air is not None:
        corps["humidite_air"] = humidite_air

    resp = requests.patch(
        f"{BASE_URL}/irrigation/parcelles/{PARCELLE_ID}/mesures/temps-reel/",
        headers={"X-Device-Key": DEVICE_KEY},
        json=corps,
    )
    print("Mesure envoyée ->", resp.status_code, resp.json())


def etat_pompe():
    resp = requests.get(
        f"{BASE_URL}/irrigation/parcelles/{PARCELLE_ID}/pompe/etat/",
        headers={"X-Device-Key": DEVICE_KEY},
    )

    print("État pompe ->", resp.status_code)
    print("Content-Type ->", resp.headers.get("Content-Type"))
    print("Réponse brute ->", repr(resp.text))

    return resp


def main():
    print("=== 1. Connexion + passage en mode automatique ===")
    token = se_connecter()
    passer_en_mode_auto(token)

    print("\n=== 2. Humidité basse (20%) -> la pompe doit démarrer ===")
    envoyer_mesure(humidite_sol=40, temperature=17, humidite_air=35)
    etat = etat_pompe()
    assert etat["irrigation_actif"] is True, "La pompe aurait dû démarrer !"
    print("OK : la pompe a démarré automatiquement.")

    print("\n=== 3. Humidité haute (60%) -> la pompe doit s'arrêter ===")
    envoyer_mesure(humidite_sol=58)
    etat = etat_pompe()
    assert etat["irrigation_actif"] is False, "La pompe aurait dû s'arrêter !"
    print("OK : la pompe s'est arrêtée automatiquement.")

    print("\n=== 4. Zone intermédiaire (45%) -> rien ne doit changer (hystérésis) ===")
    envoyer_mesure(humidite_sol=43)
    etat = etat_pompe()
    print("État inchangé attendu ->", etat)

    print("\n=== 5. Mauvaise clé d'appareil -> doit être refusé (401) ===")
    resp = requests.patch(
        f"{BASE_URL}/irrigation/parcelles/{PARCELLE_ID}/mesures/temps-reel/",
        headers={"X-Device-Key": "fausse-cle"},
        json={"temperature": 30},
    )
    print("Résultat ->", resp.status_code)
    assert resp.status_code == 401

    print("\nTous les tests sont passés.")


if __name__ == "__main__":
    main()