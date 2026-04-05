#!/bin/bash



# lister les utilisateurs avec UID > 1000 
lister_utilisateurs() {
    echo "Utilisateurs avec UID > 1000 :"
    echo "--------------------------------"
    while IFS=: read -r login _ uid _; do
        if [ "$uid" -gt 1000 ] 2>/dev/null; then
            echo "$login (UID=$uid)"
        fi
    done < /etc/passwd
}

# vérifier l'existence d'un utilisateur
verifier_utilisateur() {
    read -p "Entrez un login ou un UID : " saisie

    if echo "$saisie" | grep -qE '^[0-9]+$'; then
        ligne=$(grep -E "^[^:]*:[^:]*:$saisie:" /etc/passwd)
    else
        ligne=$(grep -E "^$saisie:" /etc/passwd)
    fi

    if [ -n "$ligne" ]; then
        echo "Utilisateur trouvé. Informations :"
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

#créer un utilisateur 
creer_utilisateur() {
    # Vérifier que le script est exécuté par root
    if [ "$(id -u)" -ne 0 ]; then
        echo "Erreur : vous devez être root pour créer un utilisateur."
        return 1
    fi

    read -p "Entrez le login du nouvel utilisateur : " login

    # Vérifier que le login n'est pas vide
    if [ -z "$login" ]; then
        echo "Erreur : le login ne peut pas être vide."
        return 1
    fi

    # Vérifier si l'utilisateur existe déjà
    if grep -qE "^$login:" /etc/passwd; then
        echo "Erreur : l'utilisateur '$login' existe déjà."
        return 1
    fi

    # Vérifier si le répertoire home existe déjà
    if [ -d "/home/$login" ]; then
        echo "Erreur : le répertoire /home/$login existe déjà."
        return 1
    fi

    # Créer l'utilisateur avec son répertoire personnel
    useradd -m -d "/home/$login" "$login"

    if [ $? -eq 0 ]; then
        echo "Utilisateur '$login' créé avec succès."
        echo "Répertoire personnel : /home/$login"
    else
        echo "Erreur lors de la création de l'utilisateur."
    fi
}


# Menu principal
while true; do
    echo ""
    echo "===== Gestion des utilisateurs ====="
    echo "1. Lister les utilisateurs (UID > 1000)"
    echo "2. Vérifier l'existence d'un utilisateur"
    echo "3. Créer un utilisateur"
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
