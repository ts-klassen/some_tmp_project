# 02 1,000 円未満の商品

**難易度**：★  
**学習トピック**：WHERE, ORDER BY

## 説明
`products` テーブルから **1,000 円未満 (price < 1000) の商品** の
`name`, `price` を価格の安い順に取得してください。

## 制約
* `ORDER BY price ASC` を付けること

## 想定出力例（先頭 5 行）

| name              | price |
|-------------------|-------|
| Sticker Pack      |    80 |
| USB‑C Cable       |   780 |
| …                 |   …   |
