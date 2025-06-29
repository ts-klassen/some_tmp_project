#!/usr/bin/env bash

# This script generates a graph image from the .dat files produced by
# src/recomendar.erl.  All .dat files located in priv/<graph_name>/ are plotted
# on the same figure using gnuplot.
#
# Usage:
#   ./plot.sh <graph_name> [output_image]
#
#   <graph_name>   Directory inside priv/ that contains one or more .dat files.
#   [output_image] Optional path of the resulting image (default:
#                  priv/<graph_name>.png)
#
# The X-axis represents the number of registered preferences, and the Y-axis
# represents the inversion count as described in src/recomendar.erl.

set -euo pipefail

# ----------------------
# Argument processing
# ----------------------

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <graph_name> [output_image]" >&2
  exit 1
fi

graph_name="$1"
data_dir="priv/${graph_name}"

if [[ ! -d "${data_dir}" ]]; then
  echo "Error: directory '${data_dir}' not found." >&2
  exit 1
fi

# Discover .dat files
shopt -s nullglob
dat_files=("${data_dir}"/*.dat)
shopt -u nullglob

if (( ${#dat_files[@]} == 0 )); then
  echo "Error: no .dat files found in '${data_dir}'." >&2
  exit 1
fi

# Determine output path
output_image="${2:-priv/${graph_name}.png}"

# ----------------------
# Build gnuplot "plot" line
# ----------------------

plot_cmd="plot "
for file in "${dat_files[@]}"; do
  base=$(basename "${file}" .dat)
  # Append: 'file' using 1:2 with linespoints lw 2 title 'base', \
  plot_cmd+="'${file}' using 1:2 with linespoints lw 2 title '${base}', \\
"
done
# Trim the final comma and back-slash that were added by the last iteration.
plot_cmd=${plot_cmd%, \\}

# ----------------------
# Feed commands to gnuplot
# ----------------------

gnuplot <<GNUPLOT
set terminal pngcairo size 1024,768 enhanced font 'Verdana,10'
set output '${output_image}'
set title '${graph_name}'
set xlabel 'Number of registered preference'
set ylabel 'Inversion count'
set grid
set key outside
${plot_cmd}
GNUPLOT

echo "Graph generated: ${output_image}"
