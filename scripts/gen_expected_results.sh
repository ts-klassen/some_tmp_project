#!/usr/bin/env bash
# Generate expected_results/XX.csv using queries.sql and the reference data.
# Run this once after DB is populated with init.sql.

set -euo pipefail

SQL_FILE="queries.sql"
OUT_DIR="expected_results"

# We will execute psql inside the running Docker container (service name: db)

psql_in_docker() {
    local q="$1"
    docker compose exec db bash -c "psql -U postgres -d ecdb -XAt -F',' -q -c \"$q\""
}

# Create output dir
mkdir -p "$OUT_DIR"

# 自動で最大番号を取得
TOTAL_Q=$(awk '/^-- [0-9][0-9]/ {sub(/^-- /, ""); if($1+0>max) max=$1+0} END{print max}' "$SQL_FILE")

for n in $(seq 1 "$TOTAL_Q"); do
  i=$(printf "%02d" "$n")
  query=$(awk -v num="$i" -f scripts/extract_query.awk "$SQL_FILE" \
           | sed -e '/^\s*$/d' -e 's/;[[:space:]]*$//')

  if [[ -z "$query" ]]; then
    echo "[WARN] Query $i not found in $SQL_FILE" >&2
    continue
  fi

  echo "Generating expected_results/${i}.csv ..."

  psql_in_docker "COPY ( $query ) TO STDOUT WITH CSV" \
      > "${OUT_DIR}/${i}.csv"
done

echo "Done."
