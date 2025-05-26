# 解説 11 売上上位 10 商品

[<< Previous](10_explanation.md) | [Next >>](12_explanation.md)

## 解答

```sql
SELECT p.id      AS product_id,
       p.name    AS product_name,
       SUM(oi.quantity * p.price) AS total_sales
  FROM products     AS p
  JOIN order_items AS oi
    ON p.id = oi.product_id
 GROUP BY p.id, p.name
 ORDER BY total_sales DESC
 FETCH FIRST 10 ROWS ONLY;
```

## 解説

- 問10と同様に商品ごとの売上を集計しています。
- `ORDER BY total_sales DESC`で降順にソートした後、`FETCH FIRST 10 ROWS ONLY`で上位10件に制限しています。