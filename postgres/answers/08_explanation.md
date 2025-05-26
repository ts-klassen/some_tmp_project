# 解説 08 全注文数と合計売上の算出

[<< Previous](07_explanation.md) | [Next >>](09_explanation.md)

## 解答

```sql
SELECT COUNT(*)                   AS total_orders,
       SUM(oi.quantity * p.price) AS total_sales
  FROM order_items AS oi
  JOIN products    AS p
    ON oi.product_id = p.id;
```

## 解説

- `JOIN`で`order_items`と`products`を結合し、数量と価格を掛け合わせた売上を計算しています。
- `SUM(oi.quantity * p.price)`で全注文の合計売上を集計し、`total_sales`として出力。
- `COUNT(*)`で注文行数をカウントし、`total_orders`として出力しています。