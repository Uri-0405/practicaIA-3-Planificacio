import argparse
import random

DAYS = 30

def gen_ext4_problem(out_file: str, n_rooms: int, n_res: int, seed: int,
                     max_stay: int, ensure_feasible: bool) -> None:
    rng = random.Random(seed)

    # Rooms capacities 1..4
    caps = [rng.randint(1, 4) for _ in range(n_rooms)]

    # Reservations: pax 1..4, intervals within 1..30
    # Optionally: try to make it feasible-ish by biasing pax toward available caps.
    reservations = []
    for i in range(1, n_res + 1):
        if ensure_feasible:
            # choose pax from existing capacities to reduce impossible reservations
            pax = rng.choice(caps)
        else:
            pax = rng.randint(1, 4)

        start = rng.randint(1, DAYS - 1)
        stay = rng.randint(1, max_stay)
        end = min(DAYS, start + stay)
        if end == start:  # just in case
            end = min(DAYS, start + 1)

        reservations.append((i, pax, start, end))

    with open(out_file, "w", encoding="utf-8") as f:
        f.write("(define (problem auto-ext4)\n")
        f.write("  (:domain hotel-ext4)\n\n")

        # OBJECTS
        f.write("  (:objects\n")
        # reservations
        for i in range(1, n_res + 1):
            f.write(f"    r{i} - res\n")
        # rooms
        for j in range(1, n_rooms + 1):
            f.write(f"    rm{j} - room\n")
        # days
        for d in range(1, DAYS + 1):
            f.write(f"    d{d} - day\n")
        f.write("  )\n\n")

        # INIT
        f.write("  (:init\n")
        # room capacities
        for j, cap in enumerate(caps, start=1):
            f.write(f"    (= (cap rm{j}) {cap})\n")

        # reservation pax
        for (i, pax, _s, _e) in reservations:
            f.write(f"    (= (pax r{i}) {pax})\n")

        # counters
        f.write("    (= (n-skipped) 0)\n")
        f.write("    (= (n-used) 0)\n")
        f.write("    (= (waste) 0)\n")

        # all free initially
        for j in range(1, n_rooms + 1):
            for d in range(1, DAYS + 1):
                f.write(f"    (free rm{j} d{d})\n")

        # within facts
        for (i, _pax, s, e) in reservations:
            for d in range(s, e + 1):
                f.write(f"    (within r{i} d{d})\n")

        f.write("  )\n\n")

        # GOAL: decide all reservations
        f.write("  (:goal\n")
        f.write("    (forall (?r - res) (decided ?r))\n")
        f.write("  )\n\n")

        # METRIC: lexicographic-like via weights
        # Metric-FF requires binary +: (+ A (+ B C))
        f.write("  (:metric minimize (+ (* 1000000 (n-skipped)) (+ (* 1000 (n-used)) (waste))))\n")
        f.write(")\n")

def main():
    ap = argparse.ArgumentParser(description="Generate PDDL problem for hotel-ext4 (only).")
    ap.add_argument("-o", "--out", default="auto_ext4.pddl", help="Output PDDL file")
    ap.add_argument("--rooms", type=int, default=6, help="Number of rooms")
    ap.add_argument("--res", type=int, default=12, help="Number of reservations")
    ap.add_argument("--seed", type=int, default=0, help="Random seed")
    ap.add_argument("--max-stay", type=int, default=7, help="Maximum length of stay (days)")
    ap.add_argument("--ensure-feasible", action="store_true",
                    help="Bias pax to existing room capacities to reduce impossible reservations")
    ap.add_argument("--level", choices=["easy", "medium", "hard"], help="Preset difficulty level (overrides rooms/res)")
    
    args = ap.parse_args()

    # Presets de dificultat
    if args.level == "easy":
        args.rooms = 4
        args.res = 8
        if args.out == "auto_ext4.pddl": args.out = "gen-easy.pddl"
    elif args.level == "medium":
        args.rooms = 6
        args.res = 15
        if args.out == "auto_ext4.pddl": args.out = "gen-medium.pddl"
    elif args.level == "hard":
        args.rooms = 10
        args.res = 30
        if args.out == "auto_ext4.pddl": args.out = "gen-hard.pddl"

    gen_ext4_problem(args.out, args.rooms, args.res, args.seed, args.max_stay, args.ensure_feasible)
    print(f"Generated: {args.out} (Rooms: {args.rooms}, Res: {args.res})")

if __name__ == "__main__":
    main()
