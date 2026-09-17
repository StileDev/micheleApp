from django.db.models.signals import post_save
from django.dispatch import receiver
from django.conf import settings
from .models import Parcelle, EtatIrrigation


@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_default_parcelle(sender, instance, created, **kwargs):
    """Chaque nouvel utilisateur reçoit une parcelle par défaut, pour que
    le tableau de bord ait toujours quelque chose à afficher."""
    if created:
        Parcelle.objects.create(user=instance)


@receiver(post_save, sender=Parcelle)
def create_etat_irrigation(sender, instance, created, **kwargs):
    if created:
        EtatIrrigation.objects.get_or_create(parcelle=instance)
