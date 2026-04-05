#!/bin/bash


while true; do 

	read -p "Saisir un note (ou q pour quitter) :" note
	if [ "$note" == "q" ]; then 
		echo "Au revoir"
		break
	fi

	

	if [[ "$note" -ge 16 && "$note" -le 20 ]]; then
        echo "Très bien"
    elif [[ "$note" -ge 14 && "$note" -lt 16 ]]; then
        echo "Bien"
    elif [[ "$note" -ge 12 && "$note" -lt 14 ]]; then
        echo "Assez bien"
   	elif [[ "$note" -ge 10 && "$note" -lt 12 ]]; then
        echo "Moyen"
    elif [[ "$note" -lt 10 && "$note" -ge 0 ]]; then
        echo "Insuffisant"
    else
        echo "Erreur : La note doit être comprise entre 0 et 20."
    fi

done

