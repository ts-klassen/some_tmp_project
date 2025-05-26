# 17 商品別・月別売上（小計 / 総計 含む）

**難易度**：★★★  
**学習トピック**：SELECT, GROUPING SETS

## 説明
`orders`、`order_items`、`products` を結合し、
商品ごとの月別売上、小計、全体総計を一度のクエリで取得してください。

## 制約

* GROUPING SETS を使用すること
* ORDER BY を使用すること

取得するカラムは product_id、sales_year、sales_month、total_sales の4つとし、この順序で表示してください。
小計行では sales_year と sales_month を空欄に、総計行では product_id、sales_year、sales_month を空欄にして表示してください。
結果は product_id 昇順、sales_year 昇順、sales_month 昇順で並べ替えてください。

## 想定出力例
