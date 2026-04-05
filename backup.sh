#!/bin/bash

# sauvegarde.sh - Sauvegarde des fichiers du repertoire courant vers OLD/
# Chaque fichier est copie avec la date du jour ajoutee a son nom : fichier#YYYY-MM-DD

DATE=$(date +"%Y-%m-%d")
REPERTOIRE_OLD="OLD"

# Creer le repertoire OLD s'il n'existe pas
if [ ! -d "$REPERTOIRE_OLD" ]; then
    mkdir "$REPERTOIRE_OLD"
    if [ $? -ne 0 ]; then
        echo "Erreur : impossible de creer le repertoire $REPERTOIRE_OLD."
        exit 1
    fi
    echo "Repertoire $REPERTOIRE_OLD cree."
else
    echo "Repertoire $REPERTOIRE_OLD existe deja."
fi

# Copier chaque fichier (pas les dossiers) du repertoire courant vers OLD
nb=0
for fichier in *; do
    # Ignorer les dossiers et le script lui-meme
    if [ -f "$fichier" ] && [ "$fichier" != "sauvegarde.sh" ]; then
        cp "$fichier" "$REPERTOIRE_OLD/$fichier#$DATE"
        echo "$fichier  -->  $REPERTOIRE_OLD/$fichier#$DATE"
        nb=$((nb + 1))
    fi
done

echo "-----------------------------------"
echo "Sauvegarde terminee : $nb fichier(s) copie(s)."
