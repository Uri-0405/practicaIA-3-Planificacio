(define (problem auto-ext4)
  (:domain hotel-ext4)

  (:objects
    r1 - res
    r2 - res
    r3 - res
    r4 - res
    r5 - res
    r6 - res
    r7 - res
    r8 - res
    rm1 - room
    rm2 - room
    rm3 - room
    rm4 - room
    d1 - day
    d2 - day
    d3 - day
    d4 - day
    d5 - day
    d6 - day
    d7 - day
    d8 - day
    d9 - day
    d10 - day
    d11 - day
    d12 - day
    d13 - day
    d14 - day
    d15 - day
    d16 - day
    d17 - day
    d18 - day
    d19 - day
    d20 - day
    d21 - day
    d22 - day
    d23 - day
    d24 - day
    d25 - day
    d26 - day
    d27 - day
    d28 - day
    d29 - day
    d30 - day
  )

  (:init
    (= (cap rm1) 1)
    (= (cap rm2) 4)
    (= (cap rm3) 4)
    (= (cap rm4) 1)
    (= (pax r1) 2)
    (= (pax r2) 4)
    (= (pax r3) 2)
    (= (pax r4) 4)
    (= (pax r5) 2)
    (= (pax r6) 1)
    (= (pax r7) 2)
    (= (pax r8) 4)
    (= (n-skipped) 0)
    (= (n-used) 0)
    (= (waste) 0)
    (free rm1 d1)
    (free rm1 d2)
    (free rm1 d3)
    (free rm1 d4)
    (free rm1 d5)
    (free rm1 d6)
    (free rm1 d7)
    (free rm1 d8)
    (free rm1 d9)
    (free rm1 d10)
    (free rm1 d11)
    (free rm1 d12)
    (free rm1 d13)
    (free rm1 d14)
    (free rm1 d15)
    (free rm1 d16)
    (free rm1 d17)
    (free rm1 d18)
    (free rm1 d19)
    (free rm1 d20)
    (free rm1 d21)
    (free rm1 d22)
    (free rm1 d23)
    (free rm1 d24)
    (free rm1 d25)
    (free rm1 d26)
    (free rm1 d27)
    (free rm1 d28)
    (free rm1 d29)
    (free rm1 d30)
    (free rm2 d1)
    (free rm2 d2)
    (free rm2 d3)
    (free rm2 d4)
    (free rm2 d5)
    (free rm2 d6)
    (free rm2 d7)
    (free rm2 d8)
    (free rm2 d9)
    (free rm2 d10)
    (free rm2 d11)
    (free rm2 d12)
    (free rm2 d13)
    (free rm2 d14)
    (free rm2 d15)
    (free rm2 d16)
    (free rm2 d17)
    (free rm2 d18)
    (free rm2 d19)
    (free rm2 d20)
    (free rm2 d21)
    (free rm2 d22)
    (free rm2 d23)
    (free rm2 d24)
    (free rm2 d25)
    (free rm2 d26)
    (free rm2 d27)
    (free rm2 d28)
    (free rm2 d29)
    (free rm2 d30)
    (free rm3 d1)
    (free rm3 d2)
    (free rm3 d3)
    (free rm3 d4)
    (free rm3 d5)
    (free rm3 d6)
    (free rm3 d7)
    (free rm3 d8)
    (free rm3 d9)
    (free rm3 d10)
    (free rm3 d11)
    (free rm3 d12)
    (free rm3 d13)
    (free rm3 d14)
    (free rm3 d15)
    (free rm3 d16)
    (free rm3 d17)
    (free rm3 d18)
    (free rm3 d19)
    (free rm3 d20)
    (free rm3 d21)
    (free rm3 d22)
    (free rm3 d23)
    (free rm3 d24)
    (free rm3 d25)
    (free rm3 d26)
    (free rm3 d27)
    (free rm3 d28)
    (free rm3 d29)
    (free rm3 d30)
    (free rm4 d1)
    (free rm4 d2)
    (free rm4 d3)
    (free rm4 d4)
    (free rm4 d5)
    (free rm4 d6)
    (free rm4 d7)
    (free rm4 d8)
    (free rm4 d9)
    (free rm4 d10)
    (free rm4 d11)
    (free rm4 d12)
    (free rm4 d13)
    (free rm4 d14)
    (free rm4 d15)
    (free rm4 d16)
    (free rm4 d17)
    (free rm4 d18)
    (free rm4 d19)
    (free rm4 d20)
    (free rm4 d21)
    (free rm4 d22)
    (free rm4 d23)
    (free rm4 d24)
    (free rm4 d25)
    (free rm4 d26)
    (free rm4 d27)
    (free rm4 d28)
    (free rm4 d29)
    (free rm4 d30)
    (within r1 d15)
    (within r1 d16)
    (within r1 d17)
    (within r1 d18)
    (within r1 d19)
    (within r1 d20)
    (within r1 d21)
    (within r1 d22)
    (within r2 d27)
    (within r2 d28)
    (within r2 d29)
    (within r2 d30)
    (within r3 d2)
    (within r3 d3)
    (within r3 d4)
    (within r3 d5)
    (within r3 d6)
    (within r3 d7)
    (within r4 d11)
    (within r4 d12)
    (within r5 d24)
    (within r5 d25)
    (within r5 d26)
    (within r5 d27)
    (within r6 d14)
    (within r6 d15)
    (within r6 d16)
    (within r6 d17)
    (within r6 d18)
    (within r6 d19)
    (within r6 d20)
    (within r6 d21)
    (within r7 d20)
    (within r7 d21)
    (within r7 d22)
    (within r7 d23)
    (within r8 d14)
    (within r8 d15)
    (within r8 d16)
    (within r8 d17)
  )

  (:goal
    (forall (?r - res) (decided ?r))
  )

  (:metric minimize (+ (* 1000000 (n-skipped)) (+ (* 1000 (n-used)) (waste))))
)
