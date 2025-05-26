# PostgreSQL SQL 演習課題 解答例
# （番号付きコメントの直後に 1 ステートメントで記述してください

-- 01 全商品の id, name, price 一覧
SELECT id, name, price
  FROM products;

-- 02 価格が 1000 未満の商品一覧
SELECT id, name, price
  FROM products
 WHERE price < 1000;

-- 03 全商品の id, name, price を価格の高い順に一覧
SELECT id, name, price
  FROM products
 ORDER BY price DESC;

-- 04 ユーザ名の重複排除一覧
SELECT DISTINCT name
  FROM users;

-- 05 注文明細と商品名、数量の一覧
SELECT oi.order_id,
       p.name AS product_name,
       oi.quantity
  FROM order_items AS oi
  JOIN products    AS p
    ON oi.product_id = p.id;

-- 06 ユーザとその注文 ID の一覧（未注文のユーザも含む）
SELECT u.id      AS user_id,
       u.name    AS user_name,
       o.id      AS order_id
  FROM users        AS u
  LEFT JOIN orders AS o
    ON u.id = o.user_id
 ORDER BY u.id;

-- 07 ユーザ別注文数の集計
SELECT user_id,
       COUNT(*) AS order_count
  FROM orders
 GROUP BY user_id;

-- 08 全注文数と合計売上の算出
SELECT COUNT(*)                   AS total_orders,
       SUM(oi.quantity * p.price) AS total_sales
  FROM order_items AS oi
  JOIN products    AS p
    ON oi.product_id = p.id;

-- 09 ユーザ別注文数ランキング
SELECT u.id      AS user_id,
       u.name    AS user_name,
       o.order_count
  FROM users          AS u
  LEFT JOIN (
    SELECT user_id,
           COUNT(*) AS order_count
      FROM orders
     GROUP BY user_id
  ) AS o
    ON u.id = o.user_id
 ORDER BY o.order_count DESC,
          u.id;

-- 10 売上が 100000 を超える商品の売上ランキング
SELECT p.id      AS product_id,
       p.name    AS product_name,
       SUM(oi.quantity * p.price) AS total_sales
  FROM products     AS p
  JOIN order_items AS oi
    ON p.id = oi.product_id
 GROUP BY p.id, p.name
HAVING SUM(oi.quantity * p.price) > 100000
 ORDER BY total_sales DESC;

-- 11 売上上位 10 商品
SELECT p.id      AS product_id,
       p.name    AS product_name,
       SUM(oi.quantity * p.price) AS total_sales
  FROM products     AS p
  JOIN order_items AS oi
    ON p.id = oi.product_id
 GROUP BY p.id, p.name
 ORDER BY total_sales DESC
 FETCH FIRST 10 ROWS ONLY;

-- 12 平均価格より高い商品の抽出
SELECT id,
       name,
       price
  FROM products
 WHERE price > (
       SELECT AVG(price)
         FROM products
 );

-- 13 一度も注文されていない商品の抽出
SELECT id,
       name,
       price
  FROM products
 WHERE id NOT IN (
       SELECT DISTINCT product_id
         FROM order_items
 );

-- 14 直近 3 か月の月別売上集計
WITH monthly_sales AS (
  SELECT EXTRACT(YEAR  FROM o.ordered_at) AS sales_year,
         EXTRACT(MONTH FROM o.ordered_at) AS sales_month,
         SUM(oi.quantity * p.price)      AS total_sales
    FROM orders       AS o
    JOIN order_items AS oi
      ON oi.order_id = o.id
    JOIN products    AS p
      ON p.id = oi.product_id
   GROUP BY EXTRACT(YEAR  FROM o.ordered_at),
            EXTRACT(MONTH FROM o.ordered_at)
)
SELECT sales_year,
       sales_month,
       total_sales
  FROM monthly_sales
 ORDER BY sales_year DESC,
          sales_month DESC
 FETCH FIRST 3 ROWS ONLY;

-- 15 注文ごとの商品数量割合 (%)
SELECT order_id,
       product_id,
       (quantity * 1.0)
         / SUM(quantity) OVER (PARTITION BY order_id) * 100
         AS quantity_ratio_percent
  FROM order_items
 ORDER BY order_id, quantity_ratio_percent DESC;

-- 16 過去 30 日間で注文がなかった日
WITH RECURSIVE calendar AS (
  SELECT CAST(CURRENT_DATE - INTERVAL '29' DAY AS DATE) AS day
  UNION ALL
  SELECT CAST(day + INTERVAL '1' DAY AS DATE)
    FROM calendar
   WHERE day + INTERVAL '1' DAY <= CURRENT_DATE
)
SELECT day
  FROM calendar
 WHERE day NOT IN (
       SELECT CAST(ordered_at AS DATE)
         FROM orders
        WHERE ordered_at >= CURRENT_DATE - INTERVAL '29' DAY
 );

-- 17 商品別・月別売上（小計 / 総計 含む）
SELECT p.id                                   AS product_id,
       EXTRACT(YEAR  FROM o.ordered_at)       AS sales_year,
       EXTRACT(MONTH FROM o.ordered_at)       AS sales_month,
       SUM(oi.quantity * p.price)            AS total_sales
  FROM orders       AS o
  JOIN order_items AS oi
    ON oi.order_id = o.id
  JOIN products    AS p
    ON p.id = oi.product_id
 GROUP BY GROUPING SETS (
    (p.id, EXTRACT(YEAR  FROM o.ordered_at), EXTRACT(MONTH FROM o.ordered_at)),
    (p.id),
    ()
 )
 ORDER BY p.id, sales_year, sales_month;
