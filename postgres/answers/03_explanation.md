# 解説 03 全商品の id, name, price を価格の高い順に一覧

[<< Previous](02_explanation.md) | [Next >>](04_explanation.md)

## 解答

```sql
SELECT id, name, price
  FROM products
 ORDER BY price DESC;
```

## 解説

- `ORDER BY price DESC`で価格の高い順にソートしています。
- `ASC`（昇順）はデフォルトなので、省略時は昇順になりますが、降順には`DESC`を明示する必要があります。
- WHERE句は不要なので使用せず、全件を対象としています。
- SELECT句とFROM句のみで全商品の情報を取得後、並び替えを行います。