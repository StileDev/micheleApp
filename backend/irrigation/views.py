from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import Parcelle, Materiel, EtatParcelle, ActionLog
from .serializers import (
    ParcelleSerializer,
    MaterielSerializer,
    MesureCreateSerializer,
    ParcelleDetailSerializer,
    ActionLogSerializer,
    PrevisionSerializer,
)
from .services import calculer_prevision


def get_parcelle_du_user(request, parcelle_id):
    """Une parcelle n'est visible/modifiable que par son propriétaire —
    on filtre systématiquement sur request.user pour éviter qu'un
    agriculteur accède aux parcelles d'un autre."""
    return get_object_or_404(Parcelle, id=parcelle_id, user=request.user)


class ParcelleListCreateView(generics.ListCreateAPIView):
    """GET  -> liste des parcelles de l'utilisateur connecté (écran 'Mes Parcelles')
    POST -> ajoute une parcelle (bouton '+ Ajouter une parcelle')"""

    permission_classes = [IsAuthenticated]
    serializer_class = ParcelleSerializer

    def get_queryset(self):
        return Parcelle.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ParcelleDeleteView(APIView):
    """DELETE -> bouton 'Supprimer' sur une parcelle."""

    permission_classes = [IsAuthenticated]

    def delete(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        parcelle.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ParcelleDetailView(APIView):
    """Vue complète d'une parcelle : dernières mesures, état irrigation/
    drainage, liste des matériels. Alimente l'écran 'Gestion état parcelle
    et matériels'."""

    permission_classes = [IsAuthenticated]

    def get(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        etat, _ = EtatParcelle.objects.get_or_create(parcelle=parcelle)
        derniere_mesure = parcelle.mesures.first()

        data = {
            'id': parcelle.id,
            'nom': parcelle.nom,
            'etat': etat,
            'temperature': derniere_mesure.temperature if derniere_mesure else None,
            'humidite_air': derniere_mesure.humidite_air if derniere_mesure else None,
            'humidite_sol': derniere_mesure.humidite_sol if derniere_mesure else None,
            'ph_sol': derniere_mesure.ph_sol if derniere_mesure else None,
            'derniere_mesure': derniere_mesure.created_at if derniere_mesure else None,
            'materiels': parcelle.materiels.all(),
        }
        return Response(ParcelleDetailSerializer(data).data)


class MaterielListCreateView(generics.ListCreateAPIView):
    """GET  -> liste des matériels d'une parcelle
    POST -> ajoute un matériel (champ + bouton 'Ajouter' de l'écran)"""

    permission_classes = [IsAuthenticated]
    serializer_class = MaterielSerializer

    def get_queryset(self):
        parcelle = get_parcelle_du_user(self.request, self.kwargs['parcelle_id'])
        return parcelle.materiels.all()

    def perform_create(self, serializer):
        parcelle = get_parcelle_du_user(self.request, self.kwargs['parcelle_id'])
        serializer.save(parcelle=parcelle)


class MaterielDeleteView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, parcelle_id, materiel_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        materiel = get_object_or_404(Materiel, id=materiel_id, parcelle=parcelle)
        materiel.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class MesureCreateView(generics.CreateAPIView):
    """Appelé par le capteur IoT (ESP32) de la parcelle pour pousser une
    nouvelle mesure."""

    permission_classes = [IsAuthenticated]
    serializer_class = MesureCreateSerializer

    def perform_create(self, serializer):
        parcelle = get_parcelle_du_user(self.request, self.kwargs['parcelle_id'])
        serializer.save(parcelle=parcelle)


class DemarrerIrrigationView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        etat, _ = EtatParcelle.objects.get_or_create(parcelle=parcelle)
        etat.irrigation_active = True
        etat.irrigation_demarree_a = timezone.now()
        etat.save()
        ActionLog.objects.create(parcelle=parcelle, type_action=ActionLog.IRRIGATION, statut=ActionLog.DEMARRAGE)
        # Ici viendra l'appel réel au matériel (pompe/électrovanne) une fois branché.
        return Response({'etat': 'irrigation démarrée'}, status=200)


class ArreterIrrigationView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        etat, _ = EtatParcelle.objects.get_or_create(parcelle=parcelle)
        etat.irrigation_active = False
        etat.irrigation_demarree_a = None
        etat.save()
        ActionLog.objects.create(parcelle=parcelle, type_action=ActionLog.IRRIGATION, statut=ActionLog.ARRET)
        return Response({'etat': 'irrigation arrêtée'}, status=200)


class DemarrerDrainageView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        etat, _ = EtatParcelle.objects.get_or_create(parcelle=parcelle)
        etat.drainage_actif = True
        etat.drainage_demarre_a = timezone.now()
        etat.save()
        ActionLog.objects.create(parcelle=parcelle, type_action=ActionLog.DRAINAGE, statut=ActionLog.DEMARRAGE)
        return Response({'etat': 'drainage démarré'}, status=200)


class ArreterDrainageView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        etat, _ = EtatParcelle.objects.get_or_create(parcelle=parcelle)
        etat.drainage_actif = False
        etat.drainage_demarre_a = None
        etat.save()
        ActionLog.objects.create(parcelle=parcelle, type_action=ActionLog.DRAINAGE, statut=ActionLog.ARRET)
        return Response({'etat': 'drainage arrêté'}, status=200)


class HistoriqueView(APIView):
    """Historique des actions (irrigation/drainage) d'une parcelle,
    pour l'écran 'Historique' du menu d'accueil."""

    permission_classes = [IsAuthenticated]

    def get(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        actions = parcelle.actions.all()[:50]
        return Response(ActionLogSerializer(actions, many=True).data)


class PrevisionView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, parcelle_id):
        parcelle = get_parcelle_du_user(request, parcelle_id)
        derniere_mesure = parcelle.mesures.first()
        data = calculer_prevision(derniere_mesure)
        return Response(PrevisionSerializer(data).data)
