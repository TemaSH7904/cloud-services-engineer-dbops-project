-- Добавляем цену в product (из product_info)
ALTER TABLE product ADD COLUMN price double precision;
ALTER TABLE product ADD PRIMARY KEY (id);

-- Добавляем дату в orders (из orders_date)
ALTER TABLE orders ADD COLUMN date_created date;
ALTER TABLE orders ADD PRIMARY KEY (id);

-- Внешние ключи в order_product
ALTER TABLE order_product ADD CONSTRAINT fk_order_product_product
    FOREIGN KEY (product_id) REFERENCES product (id);
ALTER TABLE order_product ADD CONSTRAINT fk_order_product_order
    FOREIGN KEY (order_id) REFERENCES orders (id);

-- Удаляем неиспользуемые таблицы
DROP TABLE product_info;
DROP TABLE orders_date;
