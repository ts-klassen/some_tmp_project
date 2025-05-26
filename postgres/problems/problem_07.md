# 07 ユーザ別注文数の集計

[<< Previous](problem_06.md) | [Next >>](problem_08.md)

**難易度**：★  
**学習トピック**：SELECT, GROUP BY, COUNT

## 説明
`orders` テーブルからユーザ (`user_id`) ごとの注文数を集計してください。

取得列は `user_id` と `COUNT(*)` の結果を `order_count` という列名（エイリアス）で取得してください。

## 制約
* GROUP BY を使用すること
* WHERE, HAVING, JOIN, ORDER BY などの追加句は使用しないこと

## 想定出力例（先頭 5 行）
 
```
 user_id | order_count 
---------+-------------
       3 |           3
       5 |           3
       4 |           3
```

---

[<< Previous](problem_06.md) | [Next >>](problem_08.md)

