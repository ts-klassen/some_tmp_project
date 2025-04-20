# 04 ユーザ毎の注文回数

**難易度**：★  
**学習トピック**：GROUP BY, 集約

## 説明
各ユーザ (`users`) ごとに何回注文したかを集計して、
注文回数 (`order_count`) の **多い順** に表示してください。

## 制約
* `ORDER BY order_count DESC, user_id` を付けること
  * 集計値が同じ場合は `user_id` 昇順で並べて **tie‑break** してください

## 想定出力例（先頭 5 行）

| user_id | user_name | order_count |
|---------|-----------|-------------|
|     101 | Alice     |          37 |
|     212 | Bob       |          35 |
| …       | …         |         …  |
