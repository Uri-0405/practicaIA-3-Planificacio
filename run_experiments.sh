#!/bin/bash

# Configuració del planificador
# Canvia "metric-ff" pel teu planificador (ex: ./ff, fast-downward, etc.)
PLANNER="/home/duck/Downloads/Metric-FF/ff"
DOMAIN="hotel-ext4-domain.pddl"

# Funció per executar un test
run_test() {
    PROBLEM=$1
    echo "----------------------------------------------------------------"
    echo "Executant: $PROBLEM"
    echo "----------------------------------------------------------------"
    
    # Comanda d'exemple per Metric-FF (ajusta segons el teu planificador)
    # -O: optimització, -o: domini, -f: problema
    # Utilitzem date +%s%N per obtenir precisió de nanosegons
    start_time=$(date +%s%N)
    $PLANNER -o $DOMAIN -f $PROBLEM > "${PROBLEM%.pddl}.log"
    end_time=$(date +%s%N)
    
    # Calcular durada en segons amb decimals
    duration_ns=$((end_time - start_time))
    # Convertir a segons (flotant)
    duration_sec=$(awk "BEGIN {printf \"%.6f\", $duration_ns/1000000000}")
    
    echo "External Total Time: $duration_sec seconds" >> "${PROBLEM%.pddl}.log"
    
    # Comprovar si s'ha trobat solució (això depèn de la sortida del planificador)
    if grep -q "found legal plan" "${PROBLEM%.pddl}.log"; then
        echo "✅ Solució trobada!"
        # Extreure cost (adaptar grep segons planificador)
        grep "plan cost" "${PROBLEM%.pddl}.log"
    else
        echo "❌ Cap solució trobada o error."
        echo "--- Contingut del LOG ---"
        cat "${PROBLEM%.pddl}.log"
        echo "-------------------------"
    fi
    echo "Log guardat a: ${PROBLEM%.pddl}.log"
    echo ""
}

# Executar tots els tests
echo "Iniciant bateria de proves..."

if ! command -v $PLANNER &> /dev/null; then
    echo "⚠️  ATENCIÓ: El planificador '$PLANNER' no s'ha trobat al PATH."
    echo "Edita aquest script i canvia la variable PLANNER per la ruta correcta."
    echo "Exemple: PLANNER='./Metric-FF/ff'"
    exit 1
fi

# Iterar sobre tots els fitxers .pddl excepte el domini
for PROBLEM in *.pddl; do
    # Saltar el fitxer de domini
    if [ "$PROBLEM" == "$DOMAIN" ]; then
        continue
    fi
    
    # Saltar fitxers de test temporals si n'hi ha
    if [[ "$PROBLEM" == test_* ]]; then
        continue
    fi

    run_test "$PROBLEM"
done

echo "Proves finalitzades."
