# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"

## Шаг 2. Создание базы данных store

```sql

CREATE DATABASE store;

```

## Шаг 3. Создание пользователя и выдача прав

```sql

-- создаём пользователя, под которым ходят автотесты и выполняются миграции

CREATE USER autotests WITH PASSWORD '1231234';

-- подключаемся к базе store

\c store

-- права на базу

GRANT ALL PRIVILEGES ON DATABASE store TO autotests;

-- права на схему public (чтобы Flyway мог создавать таблицы)

GRANT ALL PRIVILEGES ON SCHEMA public TO autotests;

-- права на все существующие и будущие таблицы

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO autotests;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO autotests;

-- права на последовательности (для identity-полей)

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO autotests;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO autotests;

```


## Шаг 10. Количество проданных сосисок за каждый день предыдущей недели

```sql
SELECT o.date_created, SUM(op.quantity)
FROM orders AS o
JOIN order_product AS op ON o.id = op.order_id
WHERE o.status = 'shipped' AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY o.date_created;
```

## Шаг 11. Оптимизация запроса с помощью индексов

Созданы индексы:

    CREATE INDEX order_product_order_id_idx ON order_product (order_id);
    CREATE INDEX orders_status_date_idx ON orders (status, date_created);

### До создания индексов

Время выполнения: ~14419 мс

    Parallel Hash Join (actual time=5941.221..14343.808 rows=81309 loops=3)
      Hash Cond: (op.order_id = o.id)
      ->  Parallel Seq Scan on order_product op (actual time=11.326..7286.488 rows=3333333 loops=3)
      ->  Parallel Seq Scan on orders o (actual time=12.796..5880.054 rows=81309 loops=3)
            Filter: status = shipped AND date_created > now() - 7 days
            Rows Removed by Filter: 3252025
    Execution Time: 14419.998 ms

### После создания индексов

Время выполнения: ~1895 мс

    Finalize GroupAggregate (actual time=1887.917..1894.379 rows=7 loops=1)
      ->  Parallel Hash Join (actual time=257.333..1834.432 rows=81309 loops=3)
            Hash Cond: (op.order_id = o.id)
            ->  Parallel Seq Scan on order_product op (actual time=0.025..419.254 rows=3333333 loops=3)
            ->  Parallel Bitmap Heap Scan on orders o (actual time=26.339..226.351 rows=81309 loops=3)
                  ->  Bitmap Index Scan on orders_status_date_idx (actual time=33.377..33.377 rows=243926 loops=1)
    Execution Time: 1895.319 ms

### Вывод

Время выполнения сократилось с ~14419 мс до ~1895 мс — примерно в 7,6 раза. Индекс orders_status_date_idx заменил полное сканирование таблицы orders (Seq Scan) на Bitmap Index Scan, что и дало основной прирост производительности.
