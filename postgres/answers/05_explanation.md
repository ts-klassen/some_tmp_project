# 解説 05 注文明細と商品名、数量の一覧

[<< Previous](04_explanation.md) | [Next >>](06_explanation.md)

## 解答

```sql
SELECT oi.order_id,
       p.name AS product_name,
       oi.quantity
  FROM order_items AS oi
  JOIN products    AS p
    ON oi.product_id = p.id;
```

## 解説

- `order_items`テーブルと`products`テーブルを`JOIN`し、`product_id`と`id`をキーに結合しています。
- `SELECT`句で注文ID、商品名（`AS`で別名設定）、数量を取得しています。
- 内部結合（`JOIN`）により、注文に紐づく商品のみが出力されます。