from django.contrib import admin
from .models import Parcelle, Mesure, EtatIrrigation


@admin.register(Parcelle)
class ParcelleAdmin(admin.ModelAdmin):
    list_display = ['nom', 'user', 'superficie', 'culture', 'created_at']
    search_fields = ['nom', 'user__email']


@admin.register(Mesure)
class MesureAdmin(admin.ModelAdmin):
    list_display = ['parcelle', 'humidite_sol', 'temperature', 'humidite_air', 'ph_sol', 'created_at']
    list_filter = ['parcelle']
    ordering = ['-created_at']


@admin.register(EtatIrrigation)
class EtatIrrigationAdmin(admin.ModelAdmin):
    list_display = ['parcelle', 'actif', 'mode', 'demarre_a', 'duree_minutes']
