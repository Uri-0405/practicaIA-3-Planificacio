import re
import sys
import glob

def parse_log(log_file):
    with open(log_file, 'r') as f:
        content = f.read()
    
    # Valors per defecte
    time = "N/A"
    length = "N/A"
    cost = "N/A"
    
    # Extreure informació típica de Metric-FF
    # Temps: "0.00 seconds total time" - convertir a mil·lisegons
    # Primer intentem buscar el temps extern (més precís)
    t_match_ext = re.search(r'External Total Time:\s+([\d\.]+)\s+seconds', content)
    t_match_int = re.search(r'([\d\.]+)\s+seconds total time', content)
    
    if t_match_ext:
        time_s = float(t_match_ext.group(1))
        time = f"{time_s * 1000:.3f}"
    elif t_match_int: 
        time_s = float(t_match_int.group(1))
        time = f"{time_s * 1000:.3f}"
    
    # Longitud: "step    8: assign r2 rm2"
    if "found legal plan" in content:
        # Count lines starting with optional "step", then digits, then colon
        steps = re.findall(r'^\s*(?:step\s+)?\d+:', content, re.MULTILINE)
        length = str(len(steps))
    
    # Cost: "plan cost: 2005.000000"
    c_match = re.search(r'plan cost:\s+([\d\.]+)', content)
    
    skipped = "N/A"
    used = "N/A"
    waste = "N/A"
    
    if c_match: 
        cost_val = float(c_match.group(1))
        cost = str(cost_val)
        
        # Decomposició del cost
        # Cost = 1000000*Skipped + 1000*Used + Waste
        skipped_val = int(cost_val // 1000000)
        rem1 = cost_val % 1000000
        used_val = int(rem1 // 1000)
        waste_val = int(rem1 % 1000)
        
        skipped = str(skipped_val)
        used = str(used_val)
        waste = str(waste_val)
    
    return time, length, cost, skipped, used, waste

def main():
    print("| Problema | Temps (ms) | Longitud Pla | Cost Total | Skipped | Habitacions Usades | Waste Total |")
    print("| :--- | :---: | :---: | :---: | :---: | :---: | :---: |")
    
    log_files = sorted(glob.glob("*.log"))
    if not log_files:
        print("No s'han trobat fitxers .log. Executa primer ./run_experiments.sh")
        return

    for log in log_files:
        # Saltar problemes hard-reduced
        if "hard-reduced" in log:
            continue
        
        prob_name = log.replace(".log", "")
        time, length, cost, skipped, used, waste = parse_log(log)
        print(f"| {prob_name} | {time} | {length} | {cost} | {skipped} | {used} | {waste} |")

if __name__ == "__main__":
    main()
