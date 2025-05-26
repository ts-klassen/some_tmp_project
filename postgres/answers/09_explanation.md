# 解説 09 ユーザ別注文数ランキング

[<< Previous](08_explanation.md) | [Next >>](10_explanation.md)

## 解答

```sql
SELECT u.id      AS user_id,
       u.name    AS user_name,
       order_counts.order_count
  FROM users          AS u
  LEFT JOIN (
    SELECT user_id,
           COUNT(*) AS order_count
      FROM orders
     GROUP BY user_id
  ) AS order_counts
    ON u.id = order_counts.user_id
 ORDER BY order_counts.order_count DESC,
          u.id;
```

## 解説

- サブクエリで`orders`を`user_id`ごとに集計し、`order_count`を算出しています。
- 外側のクエリでは`users`と`LEFT JOIN`し、注文のないユーザも含めています。
- `ORDER BY`で注文数の降順、その後`user_id`の昇順で並べ替えています。