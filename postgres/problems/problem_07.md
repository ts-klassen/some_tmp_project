# 07 ユーザ別注文数の集計

**難易度**：★  
**学習トピック**：SELECT, GROUP BY, COUNT

## 説明
`orders` テーブルからユーザ (`user_id`) ごとの注文数を集計してください。

取得列は `user_id` と `COUNT(*)` の結果を `order_count` という列名（エイリアス）で取得し、結果は `user_id` 昇順でソートしてください。

## 制約
* GROUP BY を使用すること
* WHERE, HAVING, JOIN などの追加句は使用しないこと

## 想定出力例（先頭 5 行）
