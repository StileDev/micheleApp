from rest_framework import serializers
from .models import Mesure, EtatIrrigation


class EtatIrrigationSerializer(serializers.ModelSerializer):
    class Meta:
        model = EtatIrrigation
        fields = ['actif', 'mode', 'demarre_a', 'duree_minutes']


class DashboardSerializer(serializers.Serializer):
    parcelle_nom = serializers.CharField()
    humidite_sol = serializers.FloatField(allow_null=True)
    temperature = serializers.FloatField(allow_null=True)
    humidite_air = serializers.FloatField(allow_null=True)
    ph_sol = serializers.FloatField(allow_null=True)
    derniere_mesure = serializers.DateTimeField(allow_null=True)
    etat_irrigation = EtatIrrigationSerializer()


class MesureCreateSerializer(serializers.ModelSerializer):
    """Utilisé par le capteur IoT (ESP32) pour pousser une nouvelle mesure."""

    class Meta:
        model = Mesure
        fields = ['humidite_sol', 'temperature', 'humidite_air', 'ph_sol']


class RaisonPrevisionSerializer(serializers.Serializer):
    titre = serializers.CharField()
    detail = serializers.CharField()


class PointPrevisionSerializer(serializers.Serializer):
    label = serializers.CharField()
    valeur = serializers.FloatField()


class PrevisionSerializer(serializers.Serializer):
    besoin_eau = serializers.BooleanField()
    message = serializers.CharField()
    raisons = RaisonPrevisionSerializer(many=True)
    courbe = PointPrevisionSerializer(many=True)


class ModeUpdateSerializer(serializers.Serializer):
    mode = serializers.ChoiceField(choices=EtatIrrigation.MODE_CHOICES)


class AutoToggleSerializer(serializers.Serializer):
    actif = serializers.BooleanField()


class DeclencherSerializer(serializers.Serializer):
    duree_minutes = serializers.IntegerField(min_value=1, max_value=180)
