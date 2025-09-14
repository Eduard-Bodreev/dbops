ALTER TABLE product ADD COLUMN price DOUBLE PRECISION;

UPDATE product
SET price = pi.price
FROM product_info pi
WHERE product.id = pi.product_id;

ALTER TABLE orders ADD COLUMN date_created DATE DEFAULT CURRENT_DATE;

UPDATE orders
SET date_created = od.date_created
FROM orders_date od
WHERE orders.id = od.order_id;

ALTER TABLE product ADD PRIMARY KEY (id);
ALTER TABLE orders ADD PRIMARY KEY (id);

ALTER TABLE order_product
  ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;

DROP TABLE IF EXISTS product_info;
DROP TABLE IF EXISTS orders_date;
