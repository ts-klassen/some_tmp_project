# 解説 07 ユーザ別注文数の集計

[<< Previous](06_explanation.md) | [Next >>](08_explanation.md)

## 解答

```sql
SELECT user_id,
       COUNT(*) AS order_count
  FROM orders
 GROUP BY user_id;
```

## 解説

- `GROUP BY user_id`でユーザごとに行をグループ化しています。
- `COUNT(*)`で各ユーザの注文数を集計し、`order_count`として出力しています。