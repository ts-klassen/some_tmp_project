# 11 売上上位 10 商品

[<< Previous](problem_10.md) | [Next >>](problem_12.md)

**難易度**：★★  
**学習トピック**：SELECT, JOIN, GROUP BY, ORDER BY, FETCH FIRST

## 説明
`order_items` と `products` を結合して各商品の売上（数量×価格）を計算し、`product_id`, `product_name`, `total_sales` の 3 カラムを売上降順で上位 10 商品を取得してください。

## 制約
* GROUP BY を使用すること
* ORDER BY を使用すること
* 出力カラムの順序と名前は `product_id`, `product_name`, `total_sales` とすること

## 想定出力例（先頭 5 行）
 
```
 product_id |     product_name      | total_sales 
------------+-----------------------+-------------
          5 | High-end Laptop       |      480000
          4 | 4K Monitor            |      425000
          8 | Smartphone            |       98000
``` 

---

[<< Previous](problem_10.md) | [Next >>](problem_12.md)

