from django.urls import path
from .views import UserListView, UserDeactivateView

urlpatterns = [
    path('users/', UserListView.as_view(), name='admin-user-list'),
    path('users/<int:pk>/', UserDeactivateView.as_view(), name='admin-user-deactivate'),
]