(define (problem p01-ext4)
  (:domain hotel-ext4)

  (:objects
    r1 r2 - res
    rm1 rm2 rm3 - room
    d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 - day
  )

  (:init
    ;; capacidades de habitaciones
    (= (cap rm1) 2)
    (= (cap rm2) 3)
    (= (cap rm3) 4)

    ;; personas por reserva
    (= (pax r1) 2)
    (= (pax r2) 3)

    ;; contadores (Ext4)
    (= (n-skipped) 0)
    (= (n-used) 0)
    (= (waste) 0)

    ;; inicialmente todo está libre (rooms x days)
    (free rm1 d1) (free rm1 d2) (free rm1 d3) (free rm1 d4) (free rm1 d5)
    (free rm1 d6) (free rm1 d7) (free rm1 d8) (free rm1 d9) (free rm1 d10)

    (free rm2 d1) (free rm2 d2) (free rm2 d3) (free rm2 d4) (free rm2 d5)
    (free rm2 d6) (free rm2 d7) (free rm2 d8) (free rm2 d9) (free rm2 d10)

    (free rm3 d1) (free rm3 d2) (free rm3 d3) (free rm3 d4) (free rm3 d5)
    (free rm3 d6) (free rm3 d7) (free rm3 d8) (free rm3 d9) (free rm3 d10)

    ;; definición de ocupación (within)
    ;; r1 ocupa d1..d3
    (within r1 d1) (within r1 d2) (within r1 d3)

    ;; r2 ocupa d3..d6 (solapa con r1 en d3)
    (within r2 d3) (within r2 d4) (within r2 d5) (within r2 d6)
  )

  ;; objetivo: cada reserva debe acabar "decidida" (asignada o skipped)
  (:goal
    (forall (?r - res) (decided ?r))
  )

  ;; optimización jerárquica aproximada con pesos:
  ;; 1 minimizar n-skipped
  ;; 2 minimizar n-used (habitaciones abiertas)
  ;; 3 minimizar waste (plazas desperdiciadas)
  (:metric minimize (+ (* 1000000 (n-skipped)) (+ (* 1000 (n-used)) (waste))))
)
