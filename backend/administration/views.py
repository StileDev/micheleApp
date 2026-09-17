from django.contrib.auth import get_user_model
from django.db.models import Q
from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response

from .permissions import IsAdminRole
from .serializers import ManageUserSerializer

User = get_user_model()


class UserListView(generics.ListAPIView):
    """Liste des utilisateurs, avec recherche optionnelle sur le nom ou
    l'email (?search=...). Seuls les comptes actifs sont renvoyés."""

    permission_classes = [IsAdminRole]
    serializer_class = ManageUserSerializer

    def get_queryset(self):
        queryset = User.objects.filter(is_active=True).order_by('full_name')
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(
                Q(full_name__icontains=search) | Q(email__icontains=search)
            )
        return queryset


class UserDeactivateView(APIView):
    """Désactive un compte au lieu de le supprimer définitivement, pour
    ne pas perdre l'historique des mesures/actions liées à cet utilisateur."""

    permission_classes = [IsAdminRole]

    def delete(self, request, pk):
        try:
            user = User.objects.get(pk=pk)
        except User.DoesNotExist:
            return Response({"detail": "Utilisateur introuvable."}, status=status.HTTP_404_NOT_FOUND)

        if user.pk == request.user.pk:
            return Response({"detail": "Vous ne pouvez pas désactiver votre propre compte."}, status=400)

        user.is_active = False
        user.save(update_fields=['is_active'])
        return Response(status=status.HTTP_204_NO_CONTENT)
