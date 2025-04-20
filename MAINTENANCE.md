# MAINTENANCE GUIDE — PostgreSQL SQL 演習課題

このドキュメントは **問題セットを保守・拡張する担当者向け** の手順と注意点をまとめています。
受講者（新卒メンバー）は読む必要はありません。

---

## 1. 期待結果 (`expected_results`) の更新

問題 SQL を修正・追加した場合は、正答 CSV を再生成してください。

```bash
# 1. DB コンテナ起動
docker compose up -d

# 2. 正答 CSV を再生成
scripts/gen_expected_results.sh   # expected_results/XX.csv が上書きされます

# 3. 差分確認
git diff expected_results/
```

## 2. 自動採点スクリプト `check.sh`

* 対象は 01〜17 問。`QUESTIONS` 配列で制御しています。
* `queries.sql` から番号付きコメント (`-- 01` など) を頼りに SQL を抽出し、
  コンテナ内の psql で実行 → `expected_results` と CSV 比較を行います。
* 合格ラインは 90% 以上。変更する場合は `threshold` の計算式を編集してください。

### 前提チェック
`check.sh` は実行前に次を確認します。

1. `docker` と `docker compose` が PATH にあるか
2. `db` サービスが稼働中か (`docker compose ps`)
3. Docker へのアクセス権があるか（permission denied 時にガイドを表示）

## 3. サンプルデータの拡張

`docker/db/init.sql` に含まれるデータは小規模です。性能検証用に増量したい場合は
`INSERT … SELECT generate_series` などを追加し、再度 1. の手順で期待結果を
生成してください。

## 4. ファイル構成早見表

| パス | 役割 |
|------|------|
| `queries.sql` | 正答例 (問題番号コメント付き) |
| `expected_results/XX.csv` | 採点用の期待結果 |
| `check.sh` | 受講者用自動採点スクリプト |
| `scripts/gen_expected_results.sh` | 期待結果を再生成するメンテナ向けスクリプト |
| `scripts/extract_query.awk` | `queries.sql` から n 番目の SQL を抽出 |
| `docker/` & `docker-compose.yml` | Postgres 学習用コンテナ |

---

Happy Maintaining!
