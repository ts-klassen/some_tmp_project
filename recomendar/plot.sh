#!/usr/bin/env bash

# Script to visualise the evaluation data produced by src/recomendar.erl.
#
# The evaluation generates tab-separated .dat files under priv/<graph_name>/
# (e.g. priv/all_category/*.dat, priv/correct_category/*.dat).  Each file has
# columns:
#   1. number of registered preferences  (X)
#   2. inversion count                   (Y)
#
# This helper plots the data with gnuplot.  Two modes are supported:
#   1. Per-directory plot      → ./plot.sh <graph_name>         [output.png]
#   2. Global plot (all .dat)  → ./plot.sh --all                [output.png]
#   3. Per-plot-name (reverse) → ./plot.sh --plot <plot_name>   [output.png]
#
# Defaults:
#   per-directory  → priv/<graph_name>.png
#   global         → priv/all_graphs.png
#   per-plot-name  → priv/<plot_name>.png
#
# Example:
#   ./plot.sh all_category
#   ./plot.sh correct_category ~/Desktop/correct.png
#   ./plot.sh --all  # produces priv/all_graphs.png

set -euo pipefail


# ------------------------------------
# Argument parsing / validation
# ------------------------------------

if (( $# < 1 )); then
  cat >&2 <<'USAGE'
Usage:
  Per-directory plot :  ./plot.sh <graph_name>            [output.png]
  Global plot        :  ./plot.sh --all|-a                [output.png]
  Per-plot-name plot :  ./plot.sh --plot|-p <plot_name>    [output.png]
USAGE
  exit 1
fi

# Modes
all_mode=false
plot_mode=false   # per-plot-name mode

case "$1" in
  --all|-a)
    all_mode=true; shift ;;
  --plot|-p)
    plot_mode=true; shift
    if [[ $# -lt 1 ]]; then
      echo "Error: --plot requires a plot name argument" >&2
      exit 1
    fi
    plot_name="$1"; shift ;;
  *)
    graph_name="$1"; shift ;;
esac

# ------------------------------------
# Collect dat_files & set defaults per mode
# ------------------------------------

if $all_mode; then
  # Collect every .dat under priv/*/
  shopt -s nullglob
  dat_files=(priv/*/*.dat)
  shopt -u nullglob

  if (( ${#dat_files[@]} == 0 )); then
    echo "Error: no .dat files found under priv/." >&2
    exit 1
  fi

  graph_title="all_graphs"
  output_image="${1:-priv/${graph_title}.png}"
elif $plot_mode; then
  # Gather priv/*/<plot_name>.dat
  shopt -s nullglob
  dat_files=(priv/*/"${plot_name}".dat)
  shopt -u nullglob

  if (( ${#dat_files[@]} == 0 )); then
    echo "Error: no .dat files named '${plot_name}.dat' found under priv/." >&2
    exit 1
  fi

  graph_title="${plot_name}"
  output_image="${1:-priv/${plot_name}.png}"
else
  data_dir="priv/${graph_name}"

  if [[ ! -d "${data_dir}" ]]; then
    echo "Error: directory '${data_dir}' not found." >&2
    exit 1
  fi

  shopt -s nullglob
  dat_files=("${data_dir}"/*.dat)
  shopt -u nullglob

  if (( ${#dat_files[@]} == 0 )); then
    echo "Error: no .dat files found in '${data_dir}'." >&2
    exit 1
  fi

  graph_title="${graph_name}"
  output_image="${1:-priv/${graph_name}.png}"
fi

# Replace underscores in the displayed graph title (gnuplot interprets '_' as
# subscript). Output filenames keep original underscores.
graph_title_disp="${graph_title//_/ }"

# ------------------------------------
# Build the gnuplot "plot" command
# ------------------------------------

plot_cmd="plot "
for f in "${dat_files[@]}"; do
  if $all_mode; then
    rel=${f#priv/}        # priv/dir/file.dat → dir/file
    title=${rel%.dat}     # drop extension
  elif $plot_mode; then
    # Use directory name (graph name) as legend
    dir=$(dirname "${f}")
    title=$(basename "${dir}")
  else
    # Per-directory mode: legend is file (plot) name
    title=$(basename "${f}" .dat)
  fi

  legend_title="${title//_/ }"
  plot_cmd+="'${f}' using 1:2 with linespoints lw 2 title '${legend_title}', \\
"
done

# Remove the trailing ", \\"
plot_cmd=${plot_cmd%, \\}

# ------------------------------------
# Run gnuplot
# ------------------------------------

gnuplot <<GNUPLOT
set terminal pngcairo size 1024,768 enhanced font 'Verdana,10'
set output '${output_image}'
set title '${graph_title_disp}'
set xlabel 'Number of registered preference'
set ylabel 'Inversion count'
set grid
set key outside
${plot_cmd}
GNUPLOT

echo "Graph generated: ${output_image}"
