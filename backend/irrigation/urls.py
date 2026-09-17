from django.urls import path
from .views import (
    DashboardView,
    MesureCreateView,
    PrevisionView,
    EtatIrrigationView,
    ModeUpdateView,
    AutoToggleView,
    DeclencherView,
    ArreterView,
)

urlpatterns = [
    path('dashboard/', DashboardView.as_view(), name='dashboard'),
    path('mesures/', MesureCreateView.as_view(), name='mesure-create'),
    path('prevision/', PrevisionView.as_view(), name='prevision'),
    path('etat/', EtatIrrigationView.as_view(), name='etat-irrigation'),
    path('mode/', ModeUpdateView.as_view(), name='mode-update'),
    path('auto/toggle/', AutoToggleView.as_view(), name='auto-toggle'),
    path('declencher/', DeclencherView.as_view(), name='declencher'),
    path('arreter/', ArreterView.as_view(), name='arreter'),
]
