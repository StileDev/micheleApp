from django.contrib import admin
from .models import Parcelle, Materiel, Mesure, EtatParcelle, ActionLog


@admin.register(Parcelle)
class ParcelleAdmin(admin.ModelAdmin):
    list_display = ['nom', 'user', 'superficie', 'culture', 'created_at']
    search_fields = ['nom', 'user__email']


@admin.register(Materiel)
class MaterielAdmin(admin.ModelAdmin):
    list_display = ['nom', 'parcelle', 'created_at']
    list_filter = ['parcelle']


@admin.register(Mesure)
class MesureAdmin(admin.ModelAdmin):
    list_display = ['parcelle', 'humidite_sol', 'temperature', 'humidite_air', 'ph_sol', 'created_at']
    list_filter = ['parcelle']
    ordering = ['-created_at']


@admin.register(EtatParcelle)
class EtatParcelleAdmin(admin.ModelAdmin):
    list_display = ['parcelle', 'iot_connecte', 'irrigation_active', 'drainage_actif']


@admin.register(ActionLog)
class ActionLogAdmin(admin.ModelAdmin):
    list_display = ['parcelle', 'type_action', 'statut', 'created_at']
    list_filter = ['type_action', 'statut']
    ordering = ['-created_at']
