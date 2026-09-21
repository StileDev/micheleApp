from django.db import models
from django.conf import settings


class Parcelle(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='parcelles')
    nom = models.CharField(max_length=100)
    superficie = models.FloatField(help_text="En hectares", null=True, blank=True)
    culture = models.CharField(max_length=100, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.nom} ({self.user.email})"


class Materiel(models.Model):
    """Capteur ou actionneur rattaché à une parcelle (ex: Capteur Humidité,
    ESP32, Capteur PIR...). Simple liste libre, comme dans l'écran
    'Gestion état parcelle et matériels'."""

    parcelle = models.ForeignKey(Parcelle, on_delete=models.CASCADE, related_name='materiels')
    nom = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        return f"{self.nom} — {self.parcelle.nom}"


class Mesure(models.Model):
    parcelle = models.ForeignKey(Parcelle, on_delete=models.CASCADE, related_name='mesures')
    humidite_sol = models.FloatField(help_text="Pourcentage")
    temperature = models.FloatField(help_text="Degrés Celsius")
    humidite_air = models.FloatField(help_text="Pourcentage")
    ph_sol = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Mesure {self.parcelle.nom} @ {self.created_at:%d/%m %H:%M}"


class EtatParcelle(models.Model):
    """État courant d'une parcelle : irrigation et drainage sont deux
    actions indépendantes, comme les deux boutons de l'écran WellAgriTech
    ('Démarrer l'Irrigation' / 'Démarrer le Drainage')."""

    parcelle = models.OneToOneField(Parcelle, on_delete=models.CASCADE, related_name='etat')
    iot_connecte = models.BooleanField(default=True)

    irrigation_active = models.BooleanField(default=False)
    irrigation_demarree_a = models.DateTimeField(null=True, blank=True)

    drainage_actif = models.BooleanField(default=False)
    drainage_demarre_a = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"État {self.parcelle.nom}"


class ActionLog(models.Model):
    """Historique des actions déclenchées sur une parcelle (irrigation,
    drainage), utilisé par l'écran Historique."""

    IRRIGATION = 'irrigation'
    DRAINAGE = 'drainage'
    TYPE_CHOICES = [(IRRIGATION, 'Irrigation'), (DRAINAGE, 'Drainage')]

    DEMARRAGE = 'demarrage'
    ARRET = 'arret'
    STATUT_CHOICES = [(DEMARRAGE, 'Démarrage'), (ARRET, 'Arrêt')]

    parcelle = models.ForeignKey(Parcelle, on_delete=models.CASCADE, related_name='actions')
    type_action = models.CharField(max_length=20, choices=TYPE_CHOICES)
    statut = models.CharField(max_length=20, choices=STATUT_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.get_type_action_display()} — {self.get_statut_display()} ({self.parcelle.nom})"
