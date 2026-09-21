from django.urls import path
from .views import (
    ParcelleListCreateView,
    ParcelleDeleteView,
    ParcelleDetailView,
    MaterielListCreateView,
    MaterielDeleteView,
    MesureCreateView,
    DemarrerIrrigationView,
    ArreterIrrigationView,
    DemarrerDrainageView,
    ArreterDrainageView,
    HistoriqueView,
    PrevisionView,
)

urlpatterns = [
    # Parcelles
    path('parcelles/', ParcelleListCreateView.as_view(), name='parcelle-list-create'),
    path('parcelles/<int:parcelle_id>/', ParcelleDeleteView.as_view(), name='parcelle-delete'),
    path('parcelles/<int:parcelle_id>/detail/', ParcelleDetailView.as_view(), name='parcelle-detail'),

    # Matériels
    path('parcelles/<int:parcelle_id>/materiels/', MaterielListCreateView.as_view(), name='materiel-list-create'),
    path('parcelles/<int:parcelle_id>/materiels/<int:materiel_id>/', MaterielDeleteView.as_view(), name='materiel-delete'),

    # Mesures (capteur IoT)
    path('parcelles/<int:parcelle_id>/mesures/', MesureCreateView.as_view(), name='mesure-create'),

    # Irrigation / Drainage
    path('parcelles/<int:parcelle_id>/irrigation/demarrer/', DemarrerIrrigationView.as_view(), name='irrigation-demarrer'),
    path('parcelles/<int:parcelle_id>/irrigation/arreter/', ArreterIrrigationView.as_view(), name='irrigation-arreter'),
    path('parcelles/<int:parcelle_id>/drainage/demarrer/', DemarrerDrainageView.as_view(), name='drainage-demarrer'),
    path('parcelles/<int:parcelle_id>/drainage/arreter/', ArreterDrainageView.as_view(), name='drainage-arreter'),

    # Historique et prévision
    path('parcelles/<int:parcelle_id>/historique/', HistoriqueView.as_view(), name='historique'),
    path('parcelles/<int:parcelle_id>/prevision/', PrevisionView.as_view(), name='prevision'),
]
