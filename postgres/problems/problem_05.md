# 05 注文明細と商品名、数量の一覧

[<< Previous](problem_04.md) | [Next >>](problem_06.md)

**難易度**：★  
**学習トピック**：SELECT, JOIN

## 説明
`order_items` テーブルと `products` テーブルを結合し、各注文の `order_id`, `product_name`, `quantity` を一覧で取得してください。

## 制約
* JOIN を使用すること
* WHERE, GROUP BY, HAVING, ORDER BY などの追加句は使用しないこと

## 想定出力例（先頭 5 行）
 
```
 order_id |     product_name      | quantity 
----------+-----------------------+----------
        1 | USB-C Cable           |        2
        1 | Sticker Pack          |        3
        2 | 4K Monitor            |        1
```

---

[<< Previous](problem_04.md) | [Next >>](problem_06.md)

