# 15 注文ごとの商品数量割合 (%)

[<< Previous](problem_14.md) | [Next >>](problem_16.md)

**難易度**：★★★  
**学習トピック**：SELECT, ウィンドウ関数, OVER

## 説明
`order_items` テーブルで、各注文 (`order_id`) 内の各商品が占める数量の割合を百分率で計算し、
注文ID順かつ割合降順で取得してください。

## 制約
* ウィンドウ関数を使用すること
* PARTITION BY を使用すること
 
取得するカラムは order_id、product_id、quantity_ratio_percent（各商品の数量割合を百分率で表す値）の3つとし、この順番で表示してください。  
結果は order_id 昇順、quantity_ratio_percent 降順で並べ替えてください。

## 想定出力例（先頭 5 行）
 
```
 order_id | product_id |  quantity_ratio_percent  
----------+------------+--------------------------
        1 |          2 |  60.00000000000000000000
        1 |          1 |  40.00000000000000000000
        2 |          4 |  50.00000000000000000000
```

---

[<< Previous](problem_14.md) | [Next >>](problem_16.md)

