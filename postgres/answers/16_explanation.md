# 解説 16 過去 30 日間で注文がなかった日

[<< Previous](15_explanation.md) | [Next >>](17_explanation.md)

## 解答

```sql
WITH RECURSIVE calendar AS (
  SELECT CAST(DATE '2024-02-26' - INTERVAL '29' DAY AS DATE) AS day
  UNION ALL
  SELECT CAST(day + INTERVAL '1' DAY AS DATE)
    FROM calendar
   WHERE day + INTERVAL '1' DAY <= DATE '2024-02-26'
)
SELECT day
  FROM calendar
 WHERE day NOT IN (
       SELECT CAST(ordered_at AS DATE)
         FROM orders
        WHERE ordered_at >= DATE '2024-02-26' - INTERVAL '29' DAY
 )
 ORDER BY day;
```

## 解説

- 再帰的CTEで過去30日間の日付一覧を`calendar`テーブルとして生成しています。
- `NOT IN`句で`orders`テーブルの注文日と照合し、未注文の日付を抽出しています。
- `ORDER BY`で日付の昇順に並べ替えています。
- 例では日付リテラル`DATE '2024-02-26'`を使用していますが、実運用では`CURRENT_DATE`を使うと動的に当日を基準にできます。