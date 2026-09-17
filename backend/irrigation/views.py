from django.utils import timezone
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import generics, status

from .models import EtatIrrigation
from .serializers import (
    DashboardSerializer,
    MesureCreateSerializer,
    PrevisionSerializer,
    EtatIrrigationSerializer,
    ModeUpdateSerializer,
    AutoToggleSerializer,
    DeclencherSerializer,
)
from .services import calculer_prevision


def get_parcelle_or_none(user):
    return user.parcelles.first()


class DashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        etat, _ = EtatIrrigation.objects.get_or_create(parcelle=parcelle)
        derniere_mesure = parcelle.mesures.first()

        data = {
            'parcelle_nom': parcelle.nom,
            'humidite_sol': derniere_mesure.humidite_sol if derniere_mesure else None,
            'temperature': derniere_mesure.temperature if derniere_mesure else None,
            'humidite_air': derniere_mesure.humidite_air if derniere_mesure else None,
            'ph_sol': derniere_mesure.ph_sol if derniere_mesure else None,
            'derniere_mesure': derniere_mesure.created_at if derniere_mesure else None,
            'etat_irrigation': etat,
        }
        return Response(DashboardSerializer(data).data)


class MesureCreateView(generics.CreateAPIView):
    """Appelé par le capteur IoT (ESP32) pour envoyer une nouvelle mesure.
    Sécurisé par JWT pour l'instant — à remplacer par une clé API dédiée
    au device quand tu brancheras le vrai matériel."""

    permission_classes = [IsAuthenticated]
    serializer_class = MesureCreateSerializer

    def perform_create(self, serializer):
        parcelle = get_parcelle_or_none(self.request.user)
        serializer.save(parcelle=parcelle)


class PrevisionView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        derniere_mesure = parcelle.mesures.first()
        data = calculer_prevision(derniere_mesure)
        return Response(PrevisionSerializer(data).data)


class EtatIrrigationView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        etat, _ = EtatIrrigation.objects.get_or_create(parcelle=parcelle)
        return Response(EtatIrrigationSerializer(etat).data)


class ModeUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ModeUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        etat, _ = EtatIrrigation.objects.get_or_create(parcelle=parcelle)
        etat.mode = serializer.validated_data['mode']
        # Changer de mode arrête tout cycle en cours, pour éviter toute ambiguïté.
        etat.actif = False
        etat.demarre_a = None
        etat.duree_minutes = None
        etat.save()

        return Response(EtatIrrigationSerializer(etat).data)


class AutoToggleView(APIView):
    """Active ou coupe le déclenchement automatique (uniquement pertinent
    quand mode == 'auto')."""

    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = AutoToggleSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        etat, _ = EtatIrrigation.objects.get_or_create(parcelle=parcelle)

        if etat.mode != EtatIrrigation.AUTO:
            return Response({"detail": "Passez d'abord en mode automatique."}, status=400)

        etat.actif = serializer.validated_data['actif']
        etat.demarre_a = timezone.now() if etat.actif else None
        etat.save()

        return Response(EtatIrrigationSerializer(etat).data)


class DeclencherView(APIView):
    """Déclenchement manuel d'un cycle d'irrigation."""

    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = DeclencherSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        etat, _ = EtatIrrigation.objects.get_or_create(parcelle=parcelle)
        etat.mode = EtatIrrigation.MANUEL
        etat.actif = True
        etat.demarre_a = timezone.now()
        etat.duree_minutes = serializer.validated_data['duree_minutes']
        etat.save()

        # C'est ici que tu déclencheras réellement la pompe / l'électrovanne
        # (appel au device IoT, MQTT, etc.) une fois le matériel branché.

        return Response(EtatIrrigationSerializer(etat).data, status=status.HTTP_200_OK)


class ArreterView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        parcelle = get_parcelle_or_none(request.user)
        if not parcelle:
            return Response({"detail": "Aucune parcelle associée à ce compte."}, status=404)

        etat, _ = EtatIrrigation.objects.get_or_create(parcelle=parcelle)
        etat.actif = False
        etat.demarre_a = None
        etat.duree_minutes = None
        etat.save()

        return Response(EtatIrrigationSerializer(etat).data)
