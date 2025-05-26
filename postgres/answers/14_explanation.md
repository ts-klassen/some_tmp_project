# 解説 14 直近 3 か月の月別売上集計

[<< Previous](13_explanation.md) | [Next >>](15_explanation.md)

## 解答

```sql
WITH monthly_sales AS (
  SELECT EXTRACT(YEAR  FROM o.ordered_at) AS sales_year,
         EXTRACT(MONTH FROM o.ordered_at) AS sales_month,
         SUM(oi.quantity * p.price)      AS total_sales
    FROM orders       AS o
    JOIN order_items AS oi
      ON oi.order_id = o.id
    JOIN products    AS p
      ON p.id = oi.product_id
   GROUP BY EXTRACT(YEAR  FROM o.ordered_at),
            EXTRACT(MONTH FROM o.ordered_at)
)
SELECT sales_year,
       sales_month,
       total_sales
  FROM monthly_sales
 ORDER BY sales_year DESC,
          sales_month DESC
 FETCH FIRST 3 ROWS ONLY;
```

## 解説

- `WITH`句(CTE)で月別売上を集計する`monthly_sales`を定義しています。
- `EXTRACT`関数で年と月を抽出し、`GROUP BY`で年月ごとに集計を行っています。
- 外側のクエリで最新3か月分を`ORDER BY`と`FETCH FIRST 3 ROWS ONLY`で取得しています。