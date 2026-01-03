# Memòria de Pràctica: Planificació Automàtica (Extensió 4)

**Autor:** [El teu Nom]  
**Data:** 03/01/2026  
**Assignatura:** Planificació Automàtica  

---

## 1. Introducció i Objectius

L'objectiu d'aquesta pràctica és estendre el domini base de gestió d'hotels per incloure criteris d'optimització avançats. En concret, l'**Extensió 4** requereix gestionar l'obertura d'habitacions de manera eficient, minimitzant el nombre total d'habitacions utilitzades i, secundàriament, minimitzant el desaprofitament de places (waste).

Els objectius d'optimització són, en ordre de prioritat:
1.  Minimitzar les reserves cancel·lades (`n-skipped`).
2.  Minimitzar el nombre d'habitacions obertes (`n-used`).
3.  Minimitzar les places buides en habitacions ocupades (`waste`).

## 2. Modelatge PDDL

Per implementar aquests requisits, s'han introduït els següents canvis al domini `hotel-ext4-domain.pddl`:

### 2.1. Predicats i Funcions
S'han afegit nous predicats i funcions numèriques per portar el compte de l'estat:
*   `(used ?rm - room)`: Predicat que indica si una habitació ja ha estat utilitzada almenys una vegada.
*   `(n-used)`: Funció que compta el total d'habitacions on `used` és cert.
*   `(waste)`: Funció que acumula la diferència entre la capacitat de l'habitació i les persones de la reserva.

### 2.2. Accions d'Assignació
Per evitar problemes amb efectes condicionals en alguns planificadors (com Metric-FF), s'ha optat per dividir l'acció d'assignar en dues accions especialitzades:

1.  **`assign-room-new`**: S'aplica quan l'habitació **no** s'ha utilitzat prèviament.
    *   *Precondició*: `(not (used ?rm))`
    *   *Efecte*: Marca `(used ?rm)` i incrementa `(n-used)`.
2.  **`assign-room-existing`**: S'aplica quan l'habitació **ja** s'ha utilitzat.
    *   *Precondició*: `(used ?rm)`
    *   *Efecte*: No incrementa `(n-used)`.

Aquesta estratègia garanteix que el comptador `n-used` només s'incrementi exactament una vegada per habitació, sense dependre de la complexitat dels efectes condicionals ni de l'ordre d'avaluació del planificador.

```lisp
(:action assign-room-new
  :parameters (?r - res ?rm - room)
  :precondition (and ... (not (used ?rm)) ...)
  :effect (and ... (used ?rm) (increase (n-used) 1) ...)
)

(:action assign-room-existing
  :parameters (?r - res ?rm - room)
  :precondition (and ... (used ?rm) ...)
  :effect (and ... ) ;; No incrementa n-used
)
```

## 3. Anàlisi de la Mètrica i Pesos

La mètrica utilitzada és una funció de cost lineal amb pesos per simular una optimització jeràrquica:

```lisp
(:metric minimize (+ (* 1000000 (n-skipped)) (* 1000 (n-used)) (waste)))
```

### Justificació Matemàtica
Per garantir que el planificador respecta l'ordre de preferències, s'ha de complir que el cost de "violar" una prioritat superior sigui més gran que el màxim cost possible de la prioritat inferior.

*   **Cost d'obrir una habitació (`n-used`)**: 1000.
*   **Cost màxim de desaprofitament (`waste`)**: El pitjor cas per reserva és assignar 1 persona a una habitació de 4 (Waste = 3).
*   **Condició de Validesa**: $W_{used} > N_{reserves} \times MaxWaste_{reserva}$

En el cas del problema més gran provat (`p04-hard` amb 30 reserves):
$$ 1000 > 30 \times 3 = 90 $$
Com que $1000 > 90$, el sistema garanteix que mai obrirà una habitació innecessària només per reduir el waste.

## 4. Experimentació i Resultats

S'han generat i executat diversos problemes de prova per validar l'escalabilitat i la correcció de la solució.

### 4.1. Definició dels Problemes
*   **p01-ext4**: Problema base (Exemple enunciat).
*   **p02-easy**: 8 reserves, 4 habitacions.
*   **p03-medium**: 15 reserves, 6 habitacions.
*   **p04-hard**: 8 reserves, 4 habitacions (Variant complexa).

### 4.2. Taula de Resultats

| Problema | Temps (s) | Longitud Pla | Cost Total | Skipped | Habitacions Usades | Waste Total |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| p01-ext4 | 0.00 | 2 | 2002.0 | 0 | 2 | 2 |
| p02-easy | 0.00 | 8 | 3002002.0 | 3 | 2 | 2 |
| p03-medium | 0.00 | 15 | 5004005.0 | 5 | 4 | 5 |
| p04-hard | 0.00 | 8 | 3002008.0 | 3 | 2 | 8 |

*(Nota: Els valors s'han obtingut executant l'script `run_experiments.sh` amb Metric-FF. S'ha limitat la mida dels problemes per respectar el límit de ~200 línies del planificador)*

## 5. Conclusions

L'extensió s'ha implementat correctament utilitzant predicats fluents i efectes condicionals. L'anàlisi dels pesos confirma que la jerarquia d'objectius es manté fins i tot per a instàncies grans del problema (fins a ~300 reserves amb els pesos actuals). Els experiments demostren que el planificador prioritza compactar les reserves en el mínim nombre d'habitacions possible.
