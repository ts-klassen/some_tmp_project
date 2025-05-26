# 02 価格が 1000 未満の商品一覧

**難易度**：★  
**学習トピック**：SELECT, WHERE, ORDER BY

## 説明
`products` テーブルから価格 (`price`) が 1000 未満の商品について、
`id`, `name`, `price` を価格の安い順に並べて取得してください。

## 制約
* WHERE句とORDER BY句を使用すること
* GROUP BY, HAVING, JOINなどの追加句は使用しないこと

## 想定出力例（先頭 5 行）

| id | name         | price |
|----|--------------|-------|
| 2  | Sticker Pack |    80 |
| 1  | USB-C Cable  |   780 |
| …  | …            |   …   |
