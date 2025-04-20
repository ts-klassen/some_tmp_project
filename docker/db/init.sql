-- ------------------------------------------------------------
-- 初期スキーマ定義 & サンプルデータ投入スクリプト
-- このファイルは Postgres 公式イメージの
-- /docker-entrypoint-initdb.d に配置されるため、
-- 初回起動時に自動実行されます。
-- ------------------------------------------------------------

-- === スキーマ定義 ===

CREATE TABLE users (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    price INTEGER       NOT NULL CHECK (price >= 0)
);

CREATE TABLE orders (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER     NOT NULL REFERENCES users(id),
    ordered_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_id   INTEGER NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id)
);

-- === サンプルデータ投入 ===

-- ユーザ
INSERT INTO users (name) VALUES
 ('Alice'),
 ('Bob'),
 ('Carol'),
 ('Dave'),
 ('Eve');

-- 商品
INSERT INTO products (name, price) VALUES
 ('USB-C Cable',                780),
 ('Sticker Pack',                80),
 ('Mechanical Keyboard',     12500),
 ('4K Monitor',              85000),
 ('High-end Laptop',        240000),
 ('Gaming Mouse',             3200),
 ('Portable SSD',            12800),
 ('Smartphone',              98000),
 ('Noise-cancel Ear-buds',   12800),
 ('Ergonomic Chair',         45000);

-- 注文
INSERT INTO orders (user_id, ordered_at) VALUES
 (1, '2024-02-01'),
 (1, '2024-02-05'),
 (2, '2024-02-03'),
 (3, '2024-02-10'),
 (3, '2024-02-12'),
 (4, '2024-02-11'),
 (5, '2024-02-14'),
 (2, '2024-02-15'),
 (5, '2024-02-16'),
 (4, '2024-02-17');

-- 注文明細
INSERT INTO order_items (order_id, product_id, quantity) VALUES
 (1, 1, 2),
 (1, 2, 3),
 (2, 4, 1),
 (2, 7, 1),
 (3, 3, 1),
 (3, 6, 2),
 (4, 5, 1),
 (5, 4, 2),
 (5, 1, 1),
 (6, 9, 1),
 (6, 7, 2),
 (7,10, 1),
 (8, 3, 2),
 (9, 5, 1),
 (9, 4, 1),
 (10,8, 1);

