# 解説 10 売上が 100000 を超える商品の売上ランキング

[<< Previous](09_explanation.md) | [Next >>](11_explanation.md)

## 解答

```sql
SELECT p.id      AS product_id,
       p.name    AS product_name,
       SUM(oi.quantity * p.price) AS total_sales
  FROM products     AS p
  JOIN order_items AS oi
    ON p.id = oi.product_id
 GROUP BY p.id, p.name
HAVING SUM(oi.quantity * p.price) > 100000
 ORDER BY total_sales DESC;
```

## 解説

- `JOIN`で`products`と`order_items`を結合し、商品ごとの売上を計算しています。
- `GROUP BY p.id, p.name`で商品ごとに集計し、`SUM(oi.quantity * p.price)`で`total_sales`を算出。
- `HAVING`句で`total_sales`が100000を超える商品に絞り込んでいます。
- `ORDER BY total_sales DESC`で売上の高い順に並べ替えています。