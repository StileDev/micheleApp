from rest_framework import serializers
from .models import Parcelle, Materiel, Mesure, EtatParcelle, ActionLog


class ParcelleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parcelle
        fields = ['id', 'nom', 'superficie', 'culture', 'latitude', 'longitude', 'created_at']
        read_only_fields = ['id', 'created_at']


class MaterielSerializer(serializers.ModelSerializer):
    class Meta:
        model = Materiel
        fields = ['id', 'nom', 'created_at']
        read_only_fields = ['id', 'created_at']


class EtatParcelleSerializer(serializers.ModelSerializer):
    class Meta:
        model = EtatParcelle
        fields = [
            'iot_connecte',
            'irrigation_active', 'irrigation_demarree_a',
            'drainage_actif', 'drainage_demarre_a',
        ]


class ParcelleDetailSerializer(serializers.Serializer):
    """Réponse complète pour l'écran 'Gestion état parcelle et matériels' :
    infos de la parcelle, dernières mesures, état, liste des matériels."""

    id = serializers.IntegerField()
    nom = serializers.CharField()
    etat = EtatParcelleSerializer()
    temperature = serializers.FloatField(allow_null=True)
    humidite_air = serializers.FloatField(allow_null=True)
    humidite_sol = serializers.FloatField(allow_null=True)
    ph_sol = serializers.FloatField(allow_null=True)
    derniere_mesure = serializers.DateTimeField(allow_null=True)
    materiels = MaterielSerializer(many=True)


class MesureCreateSerializer(serializers.ModelSerializer):
    """Utilisé par le capteur IoT (ESP32) pour pousser une nouvelle mesure
    sur une parcelle donnée."""

    class Meta:
        model = Mesure
        fields = ['humidite_sol', 'temperature', 'humidite_air', 'ph_sol']


class ActionLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActionLog
        fields = ['id', 'type_action', 'statut', 'created_at']


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
