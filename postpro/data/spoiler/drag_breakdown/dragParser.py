import re
import pandas as pd
from pathlib import Path
from collections import defaultdict

# Folder list
folder_list = ["sedan_basic", "sedan_spoiler", "coupe_basic", "coupe_spoiler"]

# Parser start
for curr_folder in (folder_list):
    # Open log file to parse drag contributes
    log_path = Path(curr_folder)/"log.solver"
    with open(log_path, "r") as f:
        log_lines = f.readlines()

    data_by_patch = defaultdict(list)
    current_time  = None
    current_patch = None

    for i, line in enumerate(log_lines):
        if line.startswith("Time ="):
            current_time = float(line.strip().split("=")[-1])
        elif line.startswith("forceCoeffs"):
            match = re.match(r'forceCoeffs\s+(.+?)\s+write:', line)
            if match:
                current_patch = match.group(1).strip()
                # search the line with Cd
                for j in range(i+1, min(i+15, len(log_lines))):
                    if log_lines[j].strip().startswith("Cd:"):
                        parts = log_lines[j].strip().split("\t")[1:4]  # Total, Pressure, Viscous
                        try:
                            values = [float(p) for p in parts]
                            data_by_patch[current_patch].append([current_time] + values)
                        except ValueError:
                            continue
                        break

    # Write drag contributes in .dat files
    output_paths = {}
    for patch, rows in data_by_patch.items():
        df = pd.DataFrame(rows, columns=["Time", "Cd Total", "Cd Pressure", "Cd Viscous"])
        df["Time"] = df["Time"].astype(int)
        for col in ["Cd Total", "Cd Pressure", "Cd Viscous"]:
            df[col] = df[col].map(lambda x: f"{x:.8f}")
        output_file = log_path.parent / f"{patch.replace(' ', '_')}.dat"
        df.to_csv(output_file, sep="\t", index=False)
        output_paths[patch] = str(output_file)

    

    

