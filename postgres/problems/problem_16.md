# 16 過去 30 日間で注文がなかった日の日付一覧

[<< Previous](problem_15.md) | [Next >>](problem_17.md)

**難易度**：★★★  
**学習トピック**：WITH, RECURSIVE, CTE

## 説明
`orders` テーブルの注文日時を保持する TIMESTAMP 型の列 `ordered_at` を用い、
2024-02-26 を起点として過去 30 日分の日付（2024-01-28 から 2024-02-26 まで、起点日を含む）を生成し、
その期間中に `ordered_at` の日付部分と一致する注文記録が存在しない日を抽出してください。

※テストの再現性確保のため、起点日は DATE '2024-02-26' に固定します。

## 制約
* WITH RECURSIVE を使用してカレンダーを生成すること
* CTE のベースケースとして DATE '2024-02-26' - INTERVAL '29' DAY を使用し、日付を 1 日ずつ展開すること
* サブクエリで `orders.ordered_at` を CAST(ordered_at AS DATE) し、カレンダーの日付と比較すること
* サブクエリには NOT IN を使用すること
* 出力カラム名は day とし、日付の昇順で並べ替えること

## 想定出力例（先頭 5 行）

```
    day     
------------
 2024-01-28
 2024-01-29
 2024-01-30
```

---

[<< Previous](problem_15.md) | [Next >>](problem_17.md)

