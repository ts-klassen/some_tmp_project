#!/usr/bin/env bash
# 簡易自動採点スクリプト
# ------------------------------------------------------------
# 前提:
# 1. Docker Compose の db サービス (ec_postgres) が起動済み
#    スクリプト内で `docker compose exec db psql` を使用します。
# 2. expected_results/XX.csv が正答として存在
#    （scripts/gen_expected_results.sh で生成可能）
# 3. queries.sql に "-- 01", "-- 02" … のコメント区切りで
#    各問 1 ステートメントが記述されている
# ------------------------------------------------------------

set -euo pipefail

# -------- command‑line options --------
DETAIL=0
if [[ ${1:-} == "--detail" || ${1:-} == "-d" ]]; then
  DETAIL=1
fi

SQL_FILE="queries.sql"
EXP_DIR="expected_results"

# ------------------------------------------------------------
# 前提チェック: Docker と docker compose の利用可否
# ------------------------------------------------------------

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed or not in PATH." >&2
  exit 1
fi

# `docker compose version` が成功するか確認
# docker compose プラグイン存在チェック
if ! docker compose version >/dev/null 2>&1; then
  echo "Error: 'docker compose' command is unavailable." >&2
  echo "Install the Docker Compose CLI plugin (docker-ce >= 20.10) or ensure it's in PATH." >&2
  exit 1
fi

# DB コンテナが起動しているか & 権限エラー検出
if ! docker compose ps --services >/tmp/compose_ps 2>/tmp/compose_err; then
  if grep -qi "permission denied" /tmp/compose_err; then
    echo "Error: Permission denied while accessing Docker." >&2
    echo "Add your user to the 'docker' group or execute this script with sudo." >&2
  else
    cat /tmp/compose_err >&2
  fi
  rm -f /tmp/compose_ps /tmp/compose_err
  exit 1
fi

if ! grep -q '^db$' /tmp/compose_ps; then
  cat /tmp/compose_err >&2
  echo "Error: Database container 'db' is not running." >&2
  echo "Run 'docker compose up -d' first, then rerun this script." >&2
  rm -f /tmp/compose_ps /tmp/compose_err
  exit 1
fi

rm -f /tmp/compose_ps /tmp/compose_err

if [[ ! -f "$SQL_FILE" ]]; then
  echo "Error: $SQL_FILE not found" >&2
  exit 1
fi

# ------------------------------
# 評価対象問題番号を自動取得
# queries.sql の先頭コメント "-- 01" などを検出して最大値を求めます。
# ------------------------------

TOTAL_Q=$(awk '/^-- [0-9][0-9]/ {sub(/^-- /, ""); if($1+0>max) max=$1+0} END{print max}' "$SQL_FILE")

if [[ -z "$TOTAL_Q" || "$TOTAL_Q" -eq 0 ]]; then
  echo "Error: Could not detect problem numbers in $SQL_FILE" >&2
  exit 1
fi

# 01,02,03 … のゼロ埋め配列を生成
QUESTIONS=()
for n in $(seq 1 "$TOTAL_Q"); do
  QUESTIONS+=( $(printf "%02d" "$n") )
done

ok=0
total=${#QUESTIONS[@]}

# tmp directory for actual outputs
tmpdir=$(mktemp -d)
trap "rm -rf '$tmpdir'" EXIT

# psql inside docker container
# run psql inside container (docker compose)
psql_in_docker() {
  local q="$1"
  docker compose exec db bash -c "psql -U postgres -d ecdb -XAt -F',' -q -c \"$q\""
}
for q in "${QUESTIONS[@]}"; do
  echo -n "Q$q ... "

  query=$(awk -v num="$q" -f scripts/extract_query.awk "$SQL_FILE" \
           | sed -e '/^\s*$/d' -e 's/;[[:space:]]*$//')

  if [[ -z "$query" ]]; then
    echo "NG (query not found)"
    continue
  fi

  outfile="$tmpdir/out_${q}.csv"

  # 実行して CSV 出力
  if ! psql_in_docker "COPY ( $query ) TO STDOUT WITH CSV" > "$outfile" 2>/dev/null; then
    echo "NG (execution error)"
    continue
  fi

  if diff -u "$EXP_DIR/$q.csv" "$outfile" >/dev/null 2>&1; then
    echo "OK"
    ok=$((ok+1))
  else
    echo "NG (mismatch)"
    if (( DETAIL == 1 )); then
      echo "----- diff for Q$q -----"
      diff -u "$EXP_DIR/$q.csv" "$outfile" | head -n 40
      echo "------------------------"
    fi
  fi
done

echo
echo "Result: $ok / $total correct"

# 合格ライン 90%
threshold=$(( total * 90 / 100 ))
if (( ok >= threshold )); then
  echo "Status: PASS"
  exit 0
else
  echo "Status: FAIL (need $threshold or more correct)"
  exit 1
fi
