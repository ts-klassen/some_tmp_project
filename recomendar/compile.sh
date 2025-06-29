#!/usr/bin/env bash

set -euo pipefail

# Ensure we always run from the project root (directory where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PRIV_DIR="priv"

# 1. If priv directory already exists, no work is necessary.
if [ -d "$PRIV_DIR" ]; then
  echo "[compile.sh] '$PRIV_DIR' already present – skipping dataset download."
  exit 0
fi

mkdir -p "$PRIV_DIR"

# 2. Download the dataset ZIP and unpack it into priv/

DATASET_URL="https://www.kaggle.com/api/v1/datasets/download/tiagosimonklassen/multideptq"
TMP_ZIP="$(mktemp -t multideptqXXXXXXX).zip"

echo "[compile.sh] Downloading dataset …"
# The dataset is public, so no authentication is required.
curl -L "$DATASET_URL" -o "$TMP_ZIP"

echo "[compile.sh] Extracting to '$PRIV_DIR' …"
unzip -q "$TMP_ZIP" -d "$PRIV_DIR"

# Clean-up temporary zip file
rm -f "$TMP_ZIP"

echo "[compile.sh] Done."

exit 0
