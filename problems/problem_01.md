# 01 価格降順で全商品の一覧

**難易度**：★  
**学習トピック**：SELECT, ORDER BY

## 説明
`products` テーブルから **全商品の `id`, `name`, `price`** を取得し、
価格 (`price`) が高い順に並べて表示してください。

## 制約
* `ORDER BY price DESC` を必ず付けること
* NULL 値は存在しないものとします

## 想定出力例（先頭 5 行）

| id | name               | price |
|----|--------------------|-------|
| 23 | High‑end Laptop    | 240000 |
| 45 | 4K Monitor         |  85000 |
| …  | …                 |   …   |
