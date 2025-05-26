# 06 ユーザとその注文 ID の一覧（未注文のユーザも含む）

**難易度**：★  
**学習トピック**：SELECT, LEFT JOIN

## 説明
`users` テーブルと `orders` テーブルを LEFT JOIN し、すべてのユーザとそれに紐付く `order_id` を一覧で取得してください。注文がないユーザも表示されるようにしてください。

## 制約
* LEFT JOIN を使用すること
* WHERE, GROUP BY, HAVING などの追加句は使用しないこと

## 想定出力例（先頭 5 行）

| user_id | user_name | order_id |
|---------|-----------|----------|
| 1       | Alice     | 1        |
| 1       | Alice     | 2        |
| 2       | Bob       | 3        |
| 2       | Bob       | 8        |
| 3       | Carol     | 4        |
