# 解説 17 商品別・月別売上（小計 / 総計 含む）

[<< Previous](16_explanation.md)

## 解答

```sql
SELECT p.id                                   AS product_id,
       EXTRACT(YEAR  FROM o.ordered_at)       AS sales_year,
       EXTRACT(MONTH FROM o.ordered_at)       AS sales_month,
       SUM(oi.quantity * p.price)            AS total_sales
  FROM orders       AS o
  JOIN order_items AS oi
    ON oi.order_id = o.id
  JOIN products    AS p
    ON p.id = oi.product_id
 GROUP BY GROUPING SETS (
    (p.id, EXTRACT(YEAR  FROM o.ordered_at), EXTRACT(MONTH FROM o.ordered_at)),
    (p.id),
    ()
 )
 ORDER BY p.id, sales_year, sales_month;
```

## 解説

- `GROUPING SETS`を使用して、(商品・年・月)ごとの集計、小計、総計を一度のクエリで取得しています。
- `()`のセットで全体総計を生成し、`(p.id)`のセットで商品ごとの小計を生成しています。
- `ORDER BY`で商品ID、年、月の順に並べ替えて見やすくしています。