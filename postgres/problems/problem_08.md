# 08 全注文数と合計売上の算出

[<< Previous](problem_07.md) | [Next >>](problem_09.md)

**難易度**：★  
**学習トピック**：SELECT, JOIN, COUNT, SUM

## 説明
`order_items` と `products` を結合し、order_items テーブルの行数（全注文アイテム数）を `total_orders`、数量×価格の合計売上を `total_sales` として算出してください。

## 制約
* JOIN を使用すること
* COUNT, SUM を使用すること
* GROUP BY などの追加句は使用しないこと
* 出力カラム名は `total_orders`, `total_sales` とすること

## 想定出力例（先頭 5 行）
```
 total_orders | total_sales 
--------------+-------------
           25 |     1215240
(1 row)
```

---

[<< Previous](problem_07.md) | [Next >>](problem_09.md)

