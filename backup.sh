#!/bin/bash



DATE=$(date +"%Y-%m-%d")
REPERTOIRE_OLD="OLD"

# Créer le répertoire OLD s'il n'existe pas
if [ ! -d "$REPERTOIRE_OLD" ]; then
    mkdir "$REPERTOIRE_OLD"
    if [ $? -ne 0 ]; then
        echo "Erreur : impossible de créer le répertoire $REPERTOIRE_OLD."
        exit 1
    fi
    echo "Répertoire $REPERTOIRE_OLD créé."
else
    echo "Répertoire $REPERTOIRE_OLD existe déjà."
fi

# Copier chaque fichier (pas les dossiers) du répertoire courant vers OLD
nb=0
for fichier in *; do
    if [ -f "$fichier" ] && [ "$fichier" != "backup.sh" ]; then
        cp "$fichier" "$REPERTOIRE_OLD/$fichier#$DATE"
        echo "$fichier  -->  $REPERTOIRE_OLD/$fichier#$DATE"
        nb=$((nb + 1))
    fi
done

echo "-----------------------------------"
echo "Sauvegarde terminée : $nb fichier(s) copié(s)."
