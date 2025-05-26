# 解説 06 ユーザとその注文 ID の一覧（未注文のユーザも含む）

[<< Previous](05_explanation.md) | [Next >>](07_explanation.md)

## 解答

```sql
SELECT u.id      AS user_id,
       u.name    AS user_name,
       o.id      AS order_id
  FROM users        AS u
  LEFT JOIN orders AS o
    ON u.id = o.user_id
 ORDER BY u.id;
```

## 解説

- `users`を基準に`LEFT JOIN`で`orders`を結合し、未注文のユーザも含めています。
- `order_id`が存在しない場合は`NULL`となり、未注文ユーザを識別できます。
- `ORDER BY u.id`でユーザIDの昇順に並べ替えています。