from django.contrib.auth.models import User
from rest_framework import serializers


class RegisterSerializer(serializers.ModelSerializer):

    password = serializers.CharField(write_only=True, min_length=8)
    password_confirmation = serializers.CharField(
        write_only=True
    )

    class Meta:
        model = User
        fields = [
            'username',
            'password',
            'password_confirmation',
        ]

    def validate(self, data):
        if data['password'] != data['password_confirmation']:
            raise serializers.ValidationError({
                'password_confirmation': 'Les mots de passe ne correspondent pas.'
            })

        return data

    def create(self, validated_data):
        validated_data.pop('password_confirmation')

        user = User.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password']
        )

        return user