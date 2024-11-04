#!/bin/bash

# Couleurs pour les messages
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Nom du fichier Docker Compose et fichier d'environnement
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

# Fonction pour afficher les messages
function print_message() {
    echo -e "${GREEN}$1${NC}"
}

function print_error() {
    echo -e "${RED}$1${NC}"
}

# Vérifie si Docker est installé
if ! [ -x "$(command -v docker)" ]; then
  print_error "Erreur : Docker n'est pas installé."
  exit 1
fi

# Vérifie si Docker Compose est installé
if ! [ -x "$(command -v docker-compose)" ]; then
  print_error "Erreur : Docker Compose n'est pas installé."
  exit 1
fi

# Vérifie si le fichier docker-compose.yml existe
if [ ! -f "$COMPOSE_FILE" ]; then
  print_error "Erreur : Le fichier $COMPOSE_FILE est introuvable."
  exit 1
fi

# Vérifie si le fichier .env existe
if [ ! -f "$ENV_FILE" ]; then
  print_error "Erreur : Le fichier $ENV_FILE est introuvable."
  exit 1
fi

# Charger les variables d'environnement depuis le fichier .env
print_message "Chargement des variables d'environnement depuis $ENV_FILE"
export $(grep -v '^#' $ENV_FILE | xargs)

# Pull des dernières images Docker
print_message "Récupération des dernières versions des images Docker..."
docker-compose pull

# Lancement des services avec Docker Compose
print_message "Démarrage des conteneurs avec Docker Compose..."
docker-compose up -d --build

# Vérifie si les conteneurs sont lancés
if [ $? -eq 0 ]; then
  print_message "Conteneurs lancés avec succès !"
else
  print_error "Erreur lors du lancement des conteneurs."
  exit 1
fi

# Afficher l'état des conteneurs
print_message "État des conteneurs :"
docker-compose ps

# Nettoyage des anciens conteneurs et images inutilisées
print_message "Nettoyage des conteneurs et images inutilisées..."
docker system prune -f

# Message final
print_message "Déploiement terminé avec succès !"