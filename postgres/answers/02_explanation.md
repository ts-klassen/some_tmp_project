# 解説 02 価格が 1000 未満の商品一覧

[<< Previous](01_explanation.md) | [Next >>](03_explanation.md)

## 解答

```sql
SELECT id, name, price
  FROM products
 WHERE price < 1000
 ORDER BY price ASC;
```

## 解説

- `WHERE price < 1000`により価格が1000未満の商品を抽出しています。
- `ORDER BY price ASC`で価格の安い順に並べています。
- `ASC`（昇順）はデフォルトなので、`ORDER BY price`と省略することもできます。
- 他の句は使用せず、必要な条件と並び順のみを指定しています。