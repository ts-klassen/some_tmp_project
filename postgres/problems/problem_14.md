# 14 直近 3 か月の月別売上集計

**難易度**：★★★  
**学習トピック**：WITH, CTE, GROUP BY, ORDER BY

## 説明
`orders`、`order_items`、`products` を結合し、注文日を年月単位で集計して月ごとの売上合計を求め、
直近 3 か月分を年月降順で取得してください。

## 制約
* WITH 句を使用して CTE を定義すること
* ORDER BY sales_year DESC, sales_month DESC と FETCH FIRST 3 ROWS ONLY を使用すること

## 想定出力例
