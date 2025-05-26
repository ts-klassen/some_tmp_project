# 12 平均価格より高い商品の抽出

**難易度**：★★  
**学習トピック**：SELECT, WHERE, サブクエリ

## 説明
`products` テーブルの平均価格を求め、その平均価格を上回る商品の id、name、price を取得してください。

## 制約
* WHERE 内でサブクエリを使用すること
* GROUP BY、HAVING、JOIN などの追加句は使用しないこと

## 想定出力例（先頭 5 行）
 
```
 id |      name       | price  
----+-----------------+--------
  4 | 4K Monitor      |  85000
  5 | High-end Laptop | 240000
  8 | Smartphone      |  98000
```
