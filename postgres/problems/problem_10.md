# 10 売上が 100000 を超える商品の売上ランキング

**難易度**：★★  
**学習トピック**：SELECT, JOIN, GROUP BY, HAVING, ORDER BY

## 説明
`order_items` と `products` を `order_items.product_id = products.id` で結合し、各商品の売上（`order_items.quantity * products.price`）を計算します。
SELECT 句では
- `order_items.product_id` AS `product_id`
- `products.name` AS `product_name`
- `SUM(order_items.quantity * products.price)` AS `total_sales`
を使用し、売上が 100000 を超える商品のみを `total_sales` 降順で取得してください。

## 制約
* GROUP BY と HAVING を使用すること
* ORDER BY を使用すること

## 想定出力例（先頭 5 行）
 
```
 product_id |  product_name   | total_sales 
------------+-----------------+-------------
          5 | High-end Laptop |      480000
          4 | 4K Monitor      |      425000
 (2 rows)
```
