#!/bin/bash



echo "Démarrage du monitoring (Ctrl+C pour arrêter)"
echo "----------------------------------------------"

while true; do
    heure=$(date +"%H:%M:%S")

    # Charge CPU : pourcentage d'utilisation (100 - idle)
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

    # Mémoire disponible en Mo
    mem_dispo=$(free -m | awk '/^Mem:/ {print $7}')
    mem_total=$(free -m | awk '/^Mem:/ {print $2}')

    echo "[$heure] CPU utilisé : ${cpu}%  |  Mémoire disponible : ${mem_dispo} Mo / ${mem_total} Mo"

    sleep 0.5
done
