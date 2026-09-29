#include <stdio.h>
int main(){

    char* entry;
    int taille = 0;
    printf("===================================\n");
    printf("Entrer votre opération : ");
    scanf("%s", entry);
    
    taille = sizeof(entry) / sizeof(entry[0]);
    printf("taille %d", taille);
    printf("\n===================================\n");
    return 0;
}