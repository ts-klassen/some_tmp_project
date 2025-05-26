# 解説 01 全商品の id, name, price 一覧

[Next >>](02_explanation.md)

## 解答

```sql
SELECT id, name, price
  FROM products;
```

## 解説

- このクエリは `products` テーブルから `id`, `name`, `price` の3つのカラムを取得します。
- `SELECT`句で取得するカラムを指定し、`FROM`句で対象テーブルを指定しています。
- 制約通り、`WHERE`や`ORDER BY`などの追加句は使用せず、最小限の構文で記述しています。