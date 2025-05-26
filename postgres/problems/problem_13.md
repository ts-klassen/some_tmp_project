# 13 一度も注文されていない商品の抽出

**難易度**：★★  
**学習トピック**：SELECT, WHERE, サブクエリ

## 説明
`order_items` テーブルに存在しない `product_id` を持つ商品を `products` テーブルから取得してください。

## 制約
* WHERE 内で NOT IN を使用すること
* JOIN、GROUP BY、HAVING などの追加句は使用しないこと

## 想定出力例

| id | name                | price |
|----|---------------------|-------|
| 2  | Sticker Pack        | 80    |
| 6  | Gaming Mouse        | 3200  |
| …  | …                   | …     |
