from django.db import models
from django.conf import settings


class Parcelle(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='parcelles')
    nom = models.CharField(max_length=100, default="Parcelle Odza")
    superficie = models.FloatField(help_text="En hectares", null=True, blank=True)
    culture = models.CharField(max_length=100, blank=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.nom} ({self.user.email})"


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


class EtatIrrigation(models.Model):
    AUTO = 'auto'
    MANUEL = 'manuel'
    MODE_CHOICES = [(AUTO, 'Automatique'), (MANUEL, 'Manuel')]

    parcelle = models.OneToOneField(Parcelle, on_delete=models.CASCADE, related_name='etat_irrigation')
    actif = models.BooleanField(default=False)
    mode = models.CharField(max_length=10, choices=MODE_CHOICES, default=AUTO)
    demarre_a = models.DateTimeField(null=True, blank=True)
    duree_minutes = models.PositiveIntegerField(null=True, blank=True)

    def __str__(self):
        return f"État irrigation {self.parcelle.nom}"
