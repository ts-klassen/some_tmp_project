# 14 直近 3 か月の月別売上集計

**難易度**：★★★  
**学習トピック**：WITH, CTE, GROUP BY, ORDER BY

## 説明
`orders`、`order_items`、`products` を結合し、注文日を年月単位で集計して月ごとの売上合計を求め、
直近 3 か月分を売上降順で取得してください。

## 制約
* WITH 句を使用して CTE を定義すること
* ORDER BY と FETCH FIRST 3 ROWS ONLY を使用すること

## 想定出力例

| sales_year | sales_month | total_sales |
|------------|-------------|-------------|
| 2024       | 2           | 123456      |
| 2024       | 1           | 112233      |
| 2023       | 12          | 445566      |
