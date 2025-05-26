# 03 全商品の id, name, price を価格の高い順に一覧

**難易度**：★  
**学習トピック**：SELECT, ORDER BY

## 説明
`products` テーブルから全商品の `id`, `name`, `price` を価格の高い順（降順）に取得してください。

## 制約
* ORDER BY句を使用すること
* WHERE, GROUP BY, HAVING, JOINなどの追加句は使用しないこと

## 想定出力例（先頭 5 行）

| id | name                 | price   |
|----|----------------------|---------|
| 5  | High-end Laptop      | 240000  |
| 4  | 4K Monitor           |  85000  |
| 10 | Ergonomic Chair      |  45000  |
| 7  | Portable SSD         |  12800  |
| 3  | Mechanical Keyboard  |  12500  |
