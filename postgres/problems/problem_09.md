# 09 ユーザ別注文数ランキング

[<< Previous](problem_08.md) | [Next >>](problem_10.md)

**難易度**：★★  
**学習トピック**：SELECT, LEFT JOIN, サブクエリ, ORDER BY

## 説明
`orders` テーブルをユーザごとに集計して注文数を求め、
その結果を `users` テーブルと結合して、各ユーザの注文数をランキング形式で取得してください。

## 制約

* サブクエリで注文数を集計すること
* LEFT JOIN を使用すること
* ORDER BY で注文数の降順、ユーザIDの昇順を指定すること
* 出力カラムのカラム名は `user_id`, `user_name`, `order_count` とすること

## 想定出力例（先頭 5 行）
 
```
user_id | user_name | order_count 
---------+-----------+-------------
      6 | Frank     |            
      1 | Alice     |           3
      2 | Bob       |           3
```

---

[<< Previous](problem_08.md) | [Next >>](problem_10.md)

