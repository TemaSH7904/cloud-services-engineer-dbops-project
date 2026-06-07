-- Индексы на внешние ключи order_product для ускорения JOIN и выборок
CREATE INDEX idx_order_product_order_id ON order_product (order_id);
CREATE INDEX idx_order_product_product_id ON order_product (product_id);
