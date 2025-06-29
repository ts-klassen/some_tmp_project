#!/usr/bin/env bash

# Bulk plot generator for the data produced by src/recomendar.erl.
#
# It relies on plot.sh to render the figures.  Running this script will:
#   1. Create ./plots/ directory (if absent).
#   2. Generate one PNG for every priv/<graph_name>/ directory.
#   3. Generate one PNG for every unique plot *file* name (e.g. administration, development…)
#   4. Generate the global "all graphs" image (every .dat).
#
# All resulting images are placed in ./plots/ with names <name>.png.

set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
plot_script="${script_dir}/plot.sh"

if [[ ! -x "${plot_script}" ]]; then
  echo "Error: plot.sh not found or not executable at ${plot_script}" >&2
  exit 1
fi

# ----------------------------------------------------
# Prepare output directory
# ----------------------------------------------------

out_dir="${script_dir}/plots"
mkdir -p "${out_dir}"

# ----------------------------------------------------
# 1. Per-directory plots (graph_name)
# ----------------------------------------------------

shopt -s nullglob
for dir in priv/*/ ; do
  graph_name=$(basename "${dir}")
  # ensure it actually contains dat files
  if compgen -G "${dir}"*.dat > /dev/null; then
    echo "[Per-dir]  ${graph_name} -> plots/${graph_name}.png"
    "${plot_script}" "${graph_name}" "${out_dir}/${graph_name}.png"
  fi
done
shopt -u nullglob

# ----------------------------------------------------
# 2. Per-plot-name images (reverse)
# ----------------------------------------------------

declare -A seen
shopt -s nullglob
for file in priv/*/*.dat ; do
  base=$(basename "${file}" .dat)
  if [[ -z "${seen[$base]:-}" ]]; then
    seen[$base]=1
    echo "[Per-plot] ${base} -> plots/${base}.png"
    "${plot_script}" --plot "${base}" "${out_dir}/${base}.png"
  fi
done
shopt -u nullglob

# ----------------------------------------------------
# 3. Global image
# ----------------------------------------------------

echo "[Global]   all_graphs -> plots/all_graphs.png"
"${plot_script}" --all "${out_dir}/everything.png"

echo "All plots generated in ${out_dir}"
