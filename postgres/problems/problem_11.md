# 11 ユーザ別累計売上 & 順位

**難易度**：★★  
**学習トピック**：ウィンドウ関数 (RANK)

## 説明
ユーザごとの **累計売上額 (`total_sales`)** を求め、
売上額が多い順に `RANK()` を使って順位 (`sales_rank`) を付けてください。

## 制約
* ウィンドウ関数 `RANK() OVER (ORDER BY …)` を使うこと

## 想定出力例（先頭 5 行）

| user_id | user_name | total_sales | sales_rank |
|---------|-----------|-------------|------------|
|     101 | Alice     | 5,678,900   |          1 |
|     212 | Bob       | 4,321,000   |          2 |
| …       | …         | …           | …          |
