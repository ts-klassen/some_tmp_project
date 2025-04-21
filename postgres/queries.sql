# PostgreSQL SQL 演習課題 解答例
# （番号付きコメントの直後に 1 ステートメントで記述してください）

-- 01 価格降順で全商品の id, name, price を表示
SELECT id, name, price
FROM products
ORDER BY price DESC;

-- 02 1,000 円未満の商品名と価格を昇順表示
SELECT name, price
FROM products
WHERE price < 1000
ORDER BY price ASC;

-- 03 全注文数と合計売上額
SELECT COUNT(DISTINCT o.id)    AS order_count,
       SUM(oi.quantity * p.price) AS total_sales
FROM orders       o
JOIN order_items  oi ON oi.order_id = o.id
JOIN products     p  ON p.id       = oi.product_id;

-- 04 ユーザ毎の注文回数 (降順)
SELECT u.id   AS user_id,
       u.name AS user_name,
       COUNT(o.id) AS order_count
FROM users  u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name
ORDER BY order_count DESC, user_id;

-- 05 各注文 ID と合計個数
SELECT order_id,
       SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
ORDER BY order_id;

-- 06 商品別累計販売個数と売上 (Top10)
SELECT p.id   AS product_id,
       p.name AS product_name,
       SUM(oi.quantity)               AS total_quantity,
       SUM(oi.quantity * p.price)     AS total_sales
FROM products     p
JOIN order_items  oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_sales DESC
LIMIT 10;

-- 07 平均価格より高い商品の一覧
SELECT id, name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- 08 一度も注文されていない商品
SELECT p.id, p.name, p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.id
)
ORDER BY p.id;

-- 09 「A さんが買ったが B さんが買っていない」商品
WITH a_products AS (
    SELECT DISTINCT p.id
    FROM products p
    JOIN order_items oi ON oi.product_id = p.id
    JOIN orders o       ON o.id = oi.order_id
    JOIN users  u       ON u.id = o.user_id
    WHERE u.name = 'A'
),
     b_products AS (
    SELECT DISTINCT p.id
    FROM products p
    JOIN order_items oi ON oi.product_id = p.id
    JOIN orders o       ON o.id = oi.order_id
    JOIN users  u       ON u.id = o.user_id
    WHERE u.name = 'B'
)
SELECT p.id, p.name
FROM products p
WHERE p.id IN (SELECT id FROM a_products)
  AND p.id NOT IN (SELECT id FROM b_products)
ORDER BY p.id;

-- 10 月別売上サマリ → 直近 3 か月抽出
WITH monthly_sales AS (
    SELECT date_trunc('month', o.ordered_at)::date AS month,
           SUM(oi.quantity * p.price)              AS total_sales
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p     ON p.id       = oi.product_id
    GROUP BY month
)
SELECT month, total_sales
FROM monthly_sales
ORDER BY month DESC
LIMIT 3;

-- 11 ユーザ別累計売上 & 順位
WITH user_sales AS (
    SELECT u.id   AS user_id,
           u.name AS user_name,
           SUM(oi.quantity * p.price) AS total_sales
    FROM users u
    JOIN orders o       ON o.user_id = u.id
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p     ON p.id       = oi.product_id
    GROUP BY u.id, u.name
)
SELECT user_id,
       user_name,
       total_sales,
       RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM user_sales
ORDER BY sales_rank;

-- 12 注文内の商品ごとの数量割合 (%)
SELECT oi.order_id,
       oi.product_id,
       ROUND(oi.quantity::numeric / SUM(oi.quantity) OVER (PARTITION BY oi.order_id) * 100, 2) AS quantity_ratio_percent
FROM order_items oi
ORDER BY oi.order_id, quantity_ratio_percent DESC;

-- 13 商品別 7 日移動平均売上
WITH daily_sales AS (
    SELECT oi.product_id,
           date_trunc('day', o.ordered_at)::date AS sales_day,
           SUM(oi.quantity * p.price)            AS daily_sales
    FROM order_items oi
    JOIN orders o   ON o.id = oi.order_id
    JOIN products p ON p.id = oi.product_id
    GROUP BY oi.product_id, sales_day
)
SELECT product_id,
       sales_day,
       AVG(daily_sales) OVER (
           PARTITION BY product_id
           ORDER BY sales_day
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) AS moving_avg_7day
FROM daily_sales
ORDER BY product_id, sales_day;

-- 14 過去 30 日で注文が無い日
WITH recent_days AS (
    SELECT generate_series(
        DATE '2024-02-17' - INTERVAL '29 day',
        DATE '2024-02-17',
        INTERVAL '1 day'
    )::date AS day
),
order_days AS (
    SELECT DISTINCT o.ordered_at::date AS day
    FROM orders o
    WHERE o.ordered_at::date BETWEEN DATE '2024-02-17' - INTERVAL '29 day'
                                 AND DATE '2024-02-17'
)
SELECT rd.day
FROM recent_days rd
LEFT JOIN order_days od ON od.day = rd.day
WHERE od.day IS NULL
ORDER BY rd.day;

-- 15 価格帯 (低/中/高) 別件数集計
SELECT CASE
           WHEN price < 1000 THEN '低'
           WHEN price < 10000 THEN '中'
           ELSE '高'
       END AS price_band,
       COUNT(*) AS product_count
FROM products
GROUP BY price_band
ORDER BY price_band;

-- 16 2023 年と 2024 年の月別売上比較
WITH monthly_sales AS (
    SELECT date_trunc('month', o.ordered_at)::date AS month,
           EXTRACT(YEAR FROM o.ordered_at)        AS year,
           SUM(oi.quantity * p.price)             AS total_sales
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p     ON p.id       = oi.product_id
    WHERE EXTRACT(YEAR FROM o.ordered_at) IN (2023, 2024)
    GROUP BY month, year
)
SELECT month, total_sales, year
FROM monthly_sales
ORDER BY month, year;

-- 17 (product_id, month) ROLLUP で小計/総計
SELECT oi.product_id,
       date_trunc('month', o.ordered_at)::date AS month,
       SUM(oi.quantity * p.price)              AS total_sales
FROM order_items oi
JOIN orders o   ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
GROUP BY ROLLUP (oi.product_id, date_trunc('month', o.ordered_at))
ORDER BY GROUPING(oi.product_id), oi.product_id, month;


