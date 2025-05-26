# 解説 12 平均価格より高い商品の抽出

[<< Previous](11_explanation.md) | [Next >>](13_explanation.md)

## 解答

```sql
SELECT id,
       name,
       price
  FROM products
 WHERE price > (
       SELECT AVG(price)
         FROM products
 );
```

## 解説

- サブクエリ`(SELECT AVG(price) FROM products)`で全商品の平均価格を取得しています。
- `WHERE price > (...)`で平均価格より高い商品を抽出しています。