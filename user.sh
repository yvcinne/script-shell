#!/bin/bash

# ---------- Fonction 1 : lister les utilisateurs avec UID > 1000 ----------
lister_utilisateurs() {
    echo "Utilisateurs avec UID > 1000 :"
    echo "--------------------------------"
    while IFS=: read -r login _ uid _; do
        if [ "$uid" -gt 1000 ] 2>/dev/null; then
            echo "$login (UID=$uid)"
        fi
    done < /etc/passwd
}

# ---------- Fonction 2 : verifier l'existence d'un utilisateur ----------
verifier_utilisateur() {
    read -p "Entrez un login ou un UID : " saisie

    # Verifier si la saisie est un nombre (UID) ou un nom (login)
    if echo "$saisie" | grep -qE '^[0-9]+$'; then
        ligne=$(grep -E "^[^:]*:[^:]*:$saisie:" /etc/passwd)
    else
        ligne=$(grep -E "^$saisie:" /etc/passwd)
    fi

    if [ -n "$ligne" ]; then
        echo "Utilisateur trouve. Informations :"
        echo "-----------------------------------"
        IFS=: read -r login _ uid gid commentaire home shell <<< "$ligne"
        echo "Login      : $login"
        echo "UID        : $uid"
        echo "GID        : $gid"
        echo "Commentaire: $commentaire"
        echo "Home       : $home"
        echo "Shell      : $shell"
    else
        echo "L'utilisateur '$saisie' n'existe pas."
    fi
}

# ---------- Fonction 3 : creer un utilisateur ----------
creer_utilisateur() {
    # Verifier que le script est execute par root
    if [ "$(id -u)" -ne 0 ]; then
        echo "Erreur : vous devez etre root pour creer un utilisateur."
        return 1
    fi

    read -p "Entrez le login du nouvel utilisateur : " login

    # Verifier que le login n'est pas vide
    if [ -z "$login" ]; then
        echo "Erreur : le login ne peut pas etre vide."
        return 1
    fi

    # Verifier si l'utilisateur existe deja
    if grep -qE "^$login:" /etc/passwd; then
        echo "Erreur : l'utilisateur '$login' existe deja."
        return 1
    fi

    # Verifier si le repertoire home existe deja
    if [ -d "/home/$login" ]; then
        echo "Erreur : le repertoire /home/$login existe deja."
        return 1
    fi

    # Creer l'utilisateur avec son repertoire personnel
    useradd -m -d "/home/$login" "$login"

    if [ $? -eq 0 ]; then
        echo "Utilisateur '$login' cree avec succes."
        echo "Repertoire personnel : /home/$login"
    else
        echo "Erreur lors de la creation de l'utilisateur."
    fi
}

# ---------- Menu principal ----------
while true; do
    echo ""
    echo "===== Gestion des utilisateurs ====="
    echo "1. Lister les utilisateurs (UID > 1000)"
    echo "2. Verifier l'existence d'un utilisateur"
    echo "3. Creer un utilisateur"
    echo "4. Quitter"
    echo "====================================="
    read -p "Votre choix : " choix

    case $choix in
        1) lister_utilisateurs ;;
        2) verifier_utilisateur ;;
        3) creer_utilisateur ;;
        4) echo "Au revoir."; exit 0 ;;
        *) echo "Choix invalide. Veuillez entrer 1, 2, 3 ou 4." ;;
    esac
done