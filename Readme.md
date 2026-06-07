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

