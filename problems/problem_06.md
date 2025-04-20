# 06 商品別累計販売個数と売上 (Top 10)

**難易度**：★★  
**学習トピック**：JOIN, GROUP BY, 集約, LIMIT

## 説明
各商品 (`products`) について、
これまでに販売された **累計数量 (`total_quantity`)** と
**累計売上額 (`total_sales`)** を計算し、
売上額の高い順に **上位 10 件** を取得してください。

## 制約
* `ORDER BY total_sales DESC` を付けること
* `LIMIT 10` を忘れないこと

## 想定出力例

| product_id | product_name      | total_quantity | total_sales |
|------------|------------------|----------------|-------------|
|        101 | High‑end Laptop  |            120 |   28,800,000|
|        234 | 4K Monitor       |            312 |   26,520,000|
| …          | …               |            …   |         …   |
