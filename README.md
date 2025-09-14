# Eduard Bodreev DBOps Project

## Как создан пользователь и какие права ему выданы

```sql
CREATE USER store_user WITH PASSWORD 'password';

GRANT CONNECT ON DATABASE store TO store_user;

ALTER SCHEMA public OWNER TO store_user;

GRANT USAGE, CREATE ON SCHEMA public TO store_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO store_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO store_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO store_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO store_user;
```

## Настройка секретов в GitHub Actions

```properties
DB_HOST=<IP_address>
DB_PORT=5432
DB_NAME=store
DB_USER=имя созданного пользователя
DB_PASSWORD=пароль созданного пользователя
```

## Запрос: сколько сосисок продано за каждый день предыдущей недели

```sql
SELECT
  o.date_created::date AS day,
  SUM(op.quantity)     AS sausages_quantity
FROM orders AS o
JOIN order_product AS op ON o.id = op.order_id
WHERE o.status = 'shipped'
  AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY day
ORDER BY day;
```
