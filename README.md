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
Si vols generar nous problemes aleatoris:
```bash
python3 gen_problem.py --out el_meu_problema.pddl --res 10 --rooms 5
```

### 2. Executar Experiments
Per llançar tots els tests definits:
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
