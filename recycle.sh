#!/bin/bash



CORBEILLE="$HOME/corbeille"
 

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  recycle -l             : lister la corbeille"
    echo "  recycle -r             : vider la corbeille"
    echo "  recycle fichier1 ...   : deplacer des fichiers vers la corbeille"
    exit 1
fi



if [ "$1" = "-l" ]; then
    if [ ! -d "$CORBEILLE" ] || [ -z "$(ls -A "$CORBEILLE" 2>/dev/null)" ]; then
        echo "La corbeille est vide."
    else
        echo "Contenu de la corbeille :"
        ls -lh "$CORBEILLE"
    fi
    exit 0
fi



if [ "$1" = "-r" ]; then
    if [ ! -d "$CORBEILLE" ] || [ -z "$(ls -A "$CORBEILLE" 2>/dev/null)" ]; then
        echo "La corbeille est deja vide."
    else
        rm -rf "${CORBEILLE:?}"/*
        echo "Corbeille videe."
    fi
    exit 0
fi


if [ ! -d "$CORBEILLE" ]; then
    mkdir -p "$CORBEILLE"
    echo "Corbeille créée : $CORBEILLE"
fi


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
    echo "$fichier deplace vers la corbeille."
done
 
exit 0