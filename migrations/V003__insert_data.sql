-- flyway:executeInTransaction=false
SET statement_timeout = 0;
SET lock_timeout = 0;
SET synchronous_commit = OFF;

INSERT INTO product (id, name, picture_url, price) VALUES
  (1, 'Сливочная',    'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00),
  (2, 'Особая',       'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00),
  (3, 'Молочная',     'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00),
  (4, 'Нюренбергская','https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00),
  (5, 'Мюнхенская',   'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00),
  (6, 'Русская',      'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00)
ON CONFLICT DO NOTHING;

TRUNCATE TABLE order_product, orders RESTART IDENTITY;

ALTER TABLE orders        SET UNLOGGED;
ALTER TABLE order_product SET UNLOGGED;

DO $$
DECLARE
  batch_size INTEGER := 100000;
  total_rows INTEGER := 10000000;
  start_i    INTEGER := 1;
  end_i      INTEGER;
BEGIN
  WHILE start_i <= total_rows LOOP
    end_i := LEAST(start_i + batch_size - 1, total_rows);

    INSERT INTO orders (id, status, date_created)
    SELECT
      i,
      (ARRAY['pending','shipped','cancelled'])[1 + floor(random() * 3)::int],
      NOW() - (random() * interval '90 days')
    FROM generate_series(start_i, end_i) s(i);

    INSERT INTO order_product (quantity, order_id, product_id)
    SELECT
      floor(1 + random() * 50)::int,
      i,
      (1 + floor(random() * 6)::int)
    FROM generate_series(start_i, end_i) s(i);

    start_i := end_i + 1;
  END LOOP;
END$$;

ALTER TABLE orders        SET LOGGED;
ALTER TABLE order_product SET LOGGED;

SELECT setval(pg_get_serial_sequence('product','id'), COALESCE((SELECT MAX(id) FROM product),1), true);
SELECT setval(pg_get_serial_sequence('orders','id'),  COALESCE((SELECT MAX(id) FROM orders),1),  true);
