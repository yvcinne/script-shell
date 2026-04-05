#!/bin/bash

# monitoring.sh - Surveillance periodique du CPU et de la memoire
# Prelèvements toutes les 0.5 secondes (sleep 0.5)

echo "Demarrage du monitoring (Ctrl+C pour arreter)"
echo "----------------------------------------------"

while true; do
    heure=$(date +"%H:%M:%S")

    # Charge CPU : pourcentage d'utilisation (100 - idle)
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

    # Memoire disponible en Mo
    mem_dispo=$(free -m | awk '/^Mem:/ {print $7}')
    mem_total=$(free -m | awk '/^Mem:/ {print $2}')

    echo "[$heure] CPU utilise : ${cpu}%  |  Memoire disponible : ${mem_dispo} Mo / ${mem_total} Mo"

    sleep 0.5
done
