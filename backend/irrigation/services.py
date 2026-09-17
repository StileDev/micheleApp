"""
Calcul de la prévision des besoins en eau.

IMPORTANT : ce module contient un calcul volontairement simple, basé sur
un seuil d'humidité du sol. C'est un point de départ pour que l'endpoint
/irrigation/prevision/ renvoie une réponse cohérente pendant que tu
développes ton propre modèle de prévision (c'est la partie la plus
importante de ton thème académique). Remplace `calculer_prevision` par
ta vraie logique (météo, évapotranspiration, historique des mesures,
modèle de prédiction...) sans avoir à toucher aux vues ni au frontend :
la forme du JSON retourné (besoin_eau, message, raisons, courbe) doit
juste rester la même.
"""

SEUIL_HUMIDITE_SOL = 50.0


def calculer_prevision(derniere_mesure):
    if derniere_mesure is None:
        return {
            'besoin_eau': False,
            'message': "Aucune mesure reçue pour le moment. La prévision sera disponible dès qu'un capteur enverra des données.",
            'raisons': [],
            'courbe': [],
        }

    humidite = derniere_mesure.humidite_sol
    besoin_eau = humidite < SEUIL_HUMIDITE_SOL

    if besoin_eau:
        message = "L'humidité du sol est sous le seuil recommandé, un arrosage est conseillé prochainement."
    else:
        message = "L'humidité du sol est à un niveau satisfaisant, aucun arrosage n'est nécessaire pour l'instant."

    raisons = [
        {
            'titre': "Humidité du sol actuelle",
            'detail': f"{humidite:.1f}%, contre un seuil de {SEUIL_HUMIDITE_SOL:.0f}% recommandé pour cette culture.",
        },
    ]

    if derniere_mesure.temperature is not None and derniere_mesure.temperature >= 28:
        raisons.append({
            'titre': "Température élevée",
            'detail': f"{derniere_mesure.temperature:.1f}°C mesurés, ce qui accélère l'évaporation de l'eau du sol.",
        })

    # Projection simplifiée sur 24h (à remplacer par un vrai modèle).
    courbe = [
        {'label': 'Maint.', 'valeur': round(humidite, 1)},
        {'label': '+6h', 'valeur': round(max(humidite - 6, 0), 1)},
        {'label': '+12h', 'valeur': round(max(humidite - 11, 0), 1)},
        {'label': '+24h', 'valeur': round(max(humidite - 18, 0), 1)},
    ]

    return {
        'besoin_eau': besoin_eau,
        'message': message,
        'raisons': raisons,
        'courbe': courbe,
    }
