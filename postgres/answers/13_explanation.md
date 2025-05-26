# 解説 13 一度も注文されていない商品の抽出

[<< Previous](12_explanation.md) | [Next >>](14_explanation.md)

## 解答

```sql
SELECT id,
       name,
       price
  FROM products
 WHERE NOT EXISTS (
       SELECT 1
         FROM order_items oi
        WHERE oi.product_id = products.id
 );
```

## 解説

- `NOT EXISTS`を使用して、`order_items`に該当行が存在しない商品を抽出しています。
- サブクエリ内で`products.id`を参照し、注文履歴がない商品を検出しています。
- `EXISTS`句は存在チェックに適しており、`JOIN`より効率的な場合があります。