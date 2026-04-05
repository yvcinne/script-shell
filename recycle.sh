#!/bin/bash


CORBEILLE="$HOME/corbeille"

# Aucun argument : afficher l'aide
if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  recycle -l             : lister la corbeille"
    echo "  recycle -r             : vider la corbeille"
    echo "  recycle fichier1 ...   : déplacer des fichiers vers la corbeille"
    exit 1
fi

# Option -l : lister la corbeille
if [ "$1" = "-l" ]; then
    if [ ! -d "$CORBEILLE" ] || [ -z "$(ls -A "$CORBEILLE" 2>/dev/null)" ]; then
        echo "La corbeille est vide."
    else
        echo "Contenu de la corbeille :"
        ls -lh "$CORBEILLE"
    fi
    exit 0
fi

# Option -r : vider la corbeille
if [ "$1" = "-r" ]; then
    if [ ! -d "$CORBEILLE" ] || [ -z "$(ls -A "$CORBEILLE" 2>/dev/null)" ]; then
        echo "La corbeille est déjà vide."
    else
        rm -rf "${CORBEILLE:?}"/*
        echo "Corbeille vidée."
    fi
    exit 0
fi

# Créer la corbeille si besoin avant de déplacer des fichiers
if [ ! -d "$CORBEILLE" ]; then
    mkdir -p "$CORBEILLE"
    echo "Corbeille créée : $CORBEILLE"
fi

# Déplacer chaque fichier/chemin passé en argument vers la corbeille
for fichier in "$@"; do
    if [ ! -e "$fichier" ]; then
        echo "Fichier introuvable : $fichier"
        continue
    fi
 
    nom_base=$(basename "$fichier")
    destination="$CORBEILLE/$nom_base"

    if [ -e "$destination" ]; then
        destination="$CORBEILLE/${nom_base}_$(date +%Y%m%d_%H%M%S)"
    fi
 
    mv "$fichier" "$destination"
    echo "$fichier déplacé vers la corbeille."
done
 
exit 0
