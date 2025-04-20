# 17 (product_id, month) ROLLUP で小計 / 総計

**難易度**：★★★  
**学習トピック**：GROUPING SET / ROLLUP

## 説明
`product_id`, `month` (注文日の月単位) の 2 軸で売上を集計し、
`ROLLUP` を用いて

1. `(product_id, month)` ごとの売上
2. `product_id` 別の小計 (month が NULL)
3. 全体の総計 (両方 NULL)

を 1 つのクエリで取得してください。

## 制約
* `GROUP BY ROLLUP (product_id, month)` を使うこと
* NULL の行が集計行であることを判断できるように、
  必要に応じて `GROUPING()` 関数を使っても構いません

## 想定出力例（抜粋）

| product_id | month      | total_sales |
|------------|-----------|-------------|
|        101 | 2024-01-01 |   1,234,000 |
|        101 | 2024-02-01 |   1,456,000 |
|        101 | NULL       |   2,690,000 | ← 小計
|       NULL | NULL       |  98,765,432 | ← 総計
