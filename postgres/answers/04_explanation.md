# 解説 04 ユーザ名の重複排除一覧

[<< Previous](03_explanation.md) | [Next >>](05_explanation.md)

## 解答

```sql
SELECT DISTINCT name
  FROM users;
```

## 解説

- `DISTINCT`を使用して、`users`テーブルの`name`列の重複値を排除しています。
- `SELECT DISTINCT`で重複のない一覧を取得できます。
- 取得するカラムは`name`のみで、シンプルなクエリです。