# Pràctica 3: Planificació Automàtica (Extensió 4)

Aquest repositori conté el codi font, els jocs de prova i els scripts d'automatització per a la Pràctica 3 de Planificació Automàtica (IA).

## Autors
* J.Oriol Ventura
* Mario Rodrigo
* Víctor Abelló

## Requisits
* **Python 3**: Per executar els scripts de generació i anàlisi.
* **Metric-FF**: El planificador utilitzat. Ha d'estar compilat i accessible.
  * L'script `run_experiments.sh` assumeix que l'executable es troba a `../Metric-FF/ff`. Si el tens en un altre lloc, edita la variable `PLANNER` dins de l'script.

## Estructura del Projecte
* `hotel-ext4-domain.pddl`: Domini PDDL amb l'Extensió 4 (optimització jeràrquica).
* `gen_problem.py`: Generador automàtic de problemes PDDL.
* `run_experiments.sh`: Script per executar la bateria de proves automàticament.
* `analyze_logs.py`: Script per extreure resultats dels logs i generar taules.
* `*.pddl`: Fitxers de problemes (base, easy, medium, hard-reduced).

## Instruccions d'Ús

### 1. Generar Problemes (Opcional)
El generador permet crear problemes aleatoris o utilitzar nivells predefinits:

```bash
# Generar un problema personalitzat
python3 gen_problem.py --out el_meu_problema.pddl --res 10 --rooms 5

# Generar els problemes estàndard (easy, medium, hard)
python3 gen_problem.py --level easy --out p02-easy.pddl
python3 gen_problem.py --level medium --out p03-medium.pddl
python3 gen_problem.py --level hard --out p04-hard.pddl
```

### 2. Executar Experiments
Per llançar tots els tests definits (busca automàticament tots els fitxers `.pddl` de la carpeta):
```bash
chmod +x run_experiments.sh
./run_experiments.sh
```
Això generarà fitxers `.log` per a cada problema.

### 3. Analitzar Resultats
Per veure la taula resum amb costos, temps i mètriques:
```bash
python3 analyze_logs.py
```

## Resultats Experimentals

A continuació es mostren els resultats obtinguts amb el planificador Metric-FF. Els temps s'han mesurat amb precisió de mil·lisegons.

| Problema | Temps (ms) | Longitud Pla | Cost Total | Skipped | Habitacions Usades | Waste Total |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| p01-ext4 | 11.131 | 2 | 2002.0 | 0 | 2 | 2 |
| p02-easy | 15.224 | 8 | 3008.0 | 0 | 3 | 8 |
| p03-medium | 27.302 | 15 | 5004006.0 | 5 | 4 | 6 |
| p04-hard | 138.250 | 30 | 3010013.0 | 3 | 10 | 13 |

### Observacions
*   **Advertència del Planificador**: Durant l'execució, el planificador Metric-FF mostra missatges del tipus `translating negated cond for predicate ...`. Vam veure aquesta advertència, però com que el planificador va trobar solucions vàlides i òptimes per a tots els problemes, vam decidir tirar endavant sense modificar el domini per evitar aquestes negacions (que són part de la traducció ADL a STRIPS interna del planificador).
*   **Escalabilitat**: S'observa com el temps de càlcul augmenta amb la complexitat del problema, però es manté en rangs molt acceptables (sota 150ms per al cas Hard).
*   **Optimització Jeràrquica**: Els costos reflecteixen correctament la jerarquia de preferències: primer minimitzar reserves saltades (pes $10^6$), després habitacions usades (pes $10^3$) i finalment el malbaratament (pes 1).
