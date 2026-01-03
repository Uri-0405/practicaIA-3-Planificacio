(define (domain hotel-ext4)
  (:requirements :strips :typing :adl :negative-preconditions :fluents)
  (:types room res day)

  (:predicates
    (free ?rm - room ?d - day)

    (assigned ?r - res)
    (skipped ?r - res)
    (decided ?r - res)

    (in ?r - res ?rm - room)
    (within ?r - res ?d - day)

    ;; NUEVO: habitación usada al menos una vez
    (used ?rm - room)
  )

  (:functions
    (cap ?rm - room)
    (pax ?r - res)

    (n-skipped)
    (n-used)
    (waste)
  )

  (:action assign-room-new
    :parameters (?r - res ?rm - room)
    :precondition (and
      (not (decided ?r))
      (not (used ?rm))
      (>= (cap ?rm) (pax ?r))
      (forall (?d - day)
        (imply (within ?r ?d) (free ?rm ?d))
      )
    )
    :effect (and
      (decided ?r)
      (assigned ?r)
      (in ?r ?rm)
      (used ?rm)
      (increase (n-used) 1)

      ;; ocupar días
      (forall (?d - day)
        (when (within ?r ?d) (not (free ?rm ?d)))
      )

      ;; desperdicio (cap - pax)
      (increase (waste) (- (cap ?rm) (pax ?r)))
    )
  )

  (:action assign-room-existing
    :parameters (?r - res ?rm - room)
    :precondition (and
      (not (decided ?r))
      (used ?rm)
      (>= (cap ?rm) (pax ?r))
      (forall (?d - day)
        (imply (within ?r ?d) (free ?rm ?d))
      )
    )
    :effect (and
      (decided ?r)
      (assigned ?r)
      (in ?r ?rm)

      ;; ocupar días
      (forall (?d - day)
        (when (within ?r ?d) (not (free ?rm ?d)))
      )

      ;; desperdicio (cap - pax)
      (increase (waste) (- (cap ?rm) (pax ?r)))
    )
  )

  (:action skip
    :parameters (?r - res)
    :precondition (and (not (decided ?r)))
    :effect (and
      (decided ?r)
      (skipped ?r)
      (increase (n-skipped) 1)
    )
  )
)
