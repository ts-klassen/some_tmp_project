# 11 売上上位 10 商品

**難易度**：★★  
**学習トピック**：SELECT, JOIN, GROUP BY, ORDER BY, FETCH FIRST

## 説明
`order_items` と `products` を結合して各商品の売上（数量×価格）を計算し、
売上上位 10 商品を売上降順で取得してください。

## 制約
* GROUP BY を使用すること
* ORDER BY を使用すること
* FETCH FIRST 10 ROWS ONLY（または LIMIT 10）を使用すること

## 想定出力例

| product_id | product_name     | total_sales |
|------------|------------------|-------------|
| 5          | High-end Laptop  | 28800000    |
| 4          | 4K Monitor       | 26520000    |
| …          | …                | …           |
