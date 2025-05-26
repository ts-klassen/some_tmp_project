# PostgreSQL SQL 演習課題

## 目的
既存スキーマ（EC サイト 4 テーブル）を使い、 **SQL の記述と理解**だけに集中して
次の基礎を修得します。

* 基本 SELECT／JOIN／集約関数
* サブクエリ・WITH 句・集合演算
* ウィンドウ関数・分析関数

---

## 前提スキーマ

| テーブル | 主なカラム | 備考 |
|----------|-----------|------|
| `users`        | `id` (PK), `name`, `created_at` |  |
| `products`     | `id` (PK), `name`, `price` | `price` は整数 (円) |
| `orders`       | `id` (PK), `user_id` (FK), `ordered_at` |  |
| `order_items`  | `order_id` (FK), `product_id` (FK), `quantity` |  |

サンプルデータはリポジトリに同梱済みです。テーブル定義やデータ投入スクリプトの変更は不要です。

---

## 問題一覧（計 17 問）

| # | 難度 | トピック | 説明 |
|---|------|----------|------|
| 01 | ★ | SELECT, FROM | 全商品の id, name, price 一覧 |
| 02 | ★ | SELECT, WHERE, ORDER BY | 価格が 1000 未満の商品一覧 |
| 03 | ★ | SELECT, ORDER BY | 全商品の id, name, price を価格の高い順に一覧 |
| 04 | ★ | SELECT, DISTINCT | ユーザ名の重複排除一覧 |
| 05 | ★  | SELECT, JOIN | 注文明細と商品名、数量の一覧 |
| 06 | ★ | SELECT, LEFT JOIN | ユーザとその注文 ID の一覧（未注文のユーザも含む） |
| 07 | ★ | SELECT, GROUP BY, COUNT | ユーザ別注文数の集計 |
| 08 | ★ | SELECT, JOIN, COUNT, SUM | 全注文数と合計売上の算出 |
| 09 | ★★ | SELECT, LEFT JOIN, サブクエリ, ORDER BY | ユーザ別注文数ランキング |
| 10 | ★★ | SELECT, JOIN, GROUP BY, HAVING, ORDER BY | 売上が 100000 を超える商品の売上ランキング |
| 11 | ★★ | SELECT, JOIN, GROUP BY, ORDER BY, FETCH FIRST | 売上上位 10 商品 |
| 12 | ★★ | SELECT, WHERE, subquery | 平均価格より高い商品の抽出 |
| 13 | ★★ | SELECT, WHERE, subquery | 一度も注文されていない商品の抽出 |
| 14 | ★★★ | WITH, CTE, GROUP BY, ORDER BY | 直近 3 か月の月別売上集計 |
| 15 | ★★★ | SELECT, window functions, OVER | 注文ごとの商品数量割合 (%) |
| 16 | ★★★ | WITH, RECURSIVE, CTE | 過去 30 日間で注文がなかった日 |
| 17 | ★★★ | SELECT, GROUPING SETS | 商品別・月別売上（小計 / 総計 含む） |

★ = 標準 / ★★ = 難しい / ★★★ = 厄介

目安時間： ★ 10 分 / ★★ 20 分 / ★★★ 30 分（1 問あたり）

---

## 提出方法

1. `queries.sql`
   * 各問題を **コメントで番号を明記**して順番に記述
   * 1 問につき 1 ステートメント
2. 自動採点

```bash
# 採点（pass / fail）
./check.sh

# 失敗した設問の diff（先頭 40 行）を表示
./check.sh --detail
```

合格ラインは **正答率 90% 以上**。不合格の場合は差分を確認して再提出してください。

---


## 自己学習・発展課題（任意）

* `EXPLAIN (ANALYZE, BUFFERS)` で 1 つ好きなクエリの実行計画を確認し、
  `Seq Scan` と `Index Scan` の違いを 3 行でまとめる  
* JSONB 列を追加し、タグ検索を `@>` 演算子で実装してみる  
* 図やブログなどで学習内容をアウトプット

---

## 参考資料

* SQLZOO — SELECT, JOIN, Aggregate 章  
* PostgreSQL 公式ドキュメント 7.2〜7.5  
* 書籍『達人に学ぶ SQL 実践入門』  

---

それでは学習を始めましょう。

---

## Docker で学習用データベースを起動する

リポジトリには Postgres コンテナを構築するための
`docker-compose.yml` と初期化 SQL（スキーマ & サンプルデータ）が同梱されています。

```bash
# 1. ビルド & 起動
docker compose up -d

# 2. コンテナ内の psql に入る（任意）
docker compose exec db bash -c "psql -U postgres -d ecdb"

# 3. 解答を一括実行する例（ホスト側のファイルを渡す）
cat queries.sql | docker compose exec -T db psql -U postgres -d ecdb
```

* デフォルト接続情報（docker-compose.yml で指定）
  * host: `localhost`
  * port: `5432`
  * user: `postgres`
  * password: `postgres`
  * database: `ecdb`

停止するときは `docker compose down`。ボリュームを残すので
テーブルや解答を再度ロードしてもデータは保持されます。

### データを初期状態に戻したいとき

演習中にテーブルを削除してしまった／データを壊した場合は、
永続ボリュームを削除してコンテナを作り直すと、同梱の init.sql が
再実行され初期データが復元されます。

```bash
# ボリュームも含めて停止・削除（データベースをリセット）
docker compose down -v

# 再起動
docker compose up -d
```

これで `users`, `products`, `orders`, `order_items` の 4 テーブルが
初期データ入りで再作成されます。

---
