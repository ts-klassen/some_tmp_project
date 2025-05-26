# 解説 15 注文ごとの商品数量割合 (%)

[<< Previous](14_explanation.md) | [Next >>](16_explanation.md)

## 解答

```sql
SELECT order_id,
       product_id,
       (quantity * 1.0)
         / SUM(quantity) OVER (PARTITION BY order_id) * 100
         AS quantity_ratio_percent
  FROM order_items
 ORDER BY order_id, quantity_ratio_percent DESC;
```

## 解説

- ウィンドウ関数`SUM(quantity) OVER (PARTITION BY order_id)`で注文ごとの総数量を計算しています。
- 各行の`quantity`を総数量で割り、`* 100`でパーセンテージを算出しています。
- `ORDER BY`で注文IDの昇順と割合の降順に並べ替えています。