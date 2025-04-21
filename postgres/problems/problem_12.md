# 12 注文内の商品ごとの数量割合 (%)

**難易度**：★★  
**学習トピック**：ウィンドウ関数 (SUM() OVER), 計算式

## 説明
各注文 (`order_items`) について、
商品ごとの数量が **注文全体の何 % を占めるか** を求め、
割合 (`quantity_ratio_percent`) を小数点 2 桁で表示してください。

## 制約
* `SUM(quantity) OVER (PARTITION BY order_id)` を用いて分母を計算すること
* パーセント計算は 100 x (個数 / 合計個数)
* 出力は必ず **`ORDER BY order_id, quantity_ratio_percent DESC`** を付け、
  まず注文 ID (`order_id`) 昇順、その中で割合が **大きい順（降順）** に並べること

## 想定出力例（先頭 5 行）

| order_id | product_id | quantity_ratio_percent |
|----------|------------|------------------------|
|      100 |        101 |                  60.00 |
|      100 |        234 |                  40.00 |
| …        |        …   |                   …    |
