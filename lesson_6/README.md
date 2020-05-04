## Урок 6. Транзакции, переменные, представления.

**1. В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.**

Создадим базы данных и таблицы. Заполним таблицу `shop.users` тестовыми данными. Таблицу `sample.users` оставим пустой.

```mysql
SOURCE example.sql;
```

<details><summary>Файл example.sql</summary>

```mysql
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
    ('Геннадий', '1990-10-05'),
    ('Наталья', '1984-11-12'),
    ('Александр', '1985-05-20'),
    ('Сергей', '1988-02-14'),
    ('Иван', '1998-01-12'),
    ('Мария', '1992-08-29');


DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';
```

</details>

Итоговые запросы:

```mysql
START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE id = 1);
DELETE FROM shop.users * WHERE id = 1 LIMIT 1;
COMMIT;
```

**2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.**

Создадим базу данных `shop` и таблицы `products` и `catalogs`. Заполним их тестовыми данными.

```mysql
SOURCE shop.sql;
```

<details><summary>Файл shop.sql</summary>

```mysql
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название раздела',
    UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
	(NULL, 'Процессоры'),
	(NULL, 'Материнские платы'),
	(NULL, 'Видеокарты'),
	(NULL, 'Жесткие диски'),
	(NULL, 'Оперативная память');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название',
    description TEXT COMMENT 'Описание',
    price DECIMAL (11,2) COMMENT 'Цена',
    catalog_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY fk_catalog_id (catalog_id) REFERENCES catalogs (id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'Товарные позиции';

INSERT INTO products
    (name, description, price, catalog_id)
VALUES
    ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
    ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
    ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
    ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
    ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
    ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
    ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);
```

</details>

Создадим представление `v1`:

```mysql
CREATE OR REPLACE VIEW v1 AS
SELECT
    p.name as product,
    c.name as catalog
FROM products as p
LEFT JOIN catalogs as c
ON p.catalog_id = c.id;

SELECT * FROM v1;
```

**3. Пусть имеется таблица с календарным полем `created_at`. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и '2018-08-17'. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.**

Создадим тестовую таблицу:

```mysql
USE sample;
DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Таблица дат';

INSERT INTO calendar VALUES
    ('2018-08-01'),
    ('2016-08-04'),
    ('2016-07-05'),
    ('2018-08-16'),
    ('2018-08-16'),
    ('2018-08-17');
```

Для решения задачи сперва создадим временную таблицу `temp` и заполним её всеми датами августа. Год не имеет значения. Далее делаем запрос к временной таблице. Вторым столбцом отмечаем, подходит ли дата к условию или нет. В подзапросе используется ключевое слово `EXISTS`, поэтому дата `2018-08-16` учитывается только один раз, хотя присутствует в таблице `calendar` дважды. Также в WHERE-условии отфильтровываем только восьмой месяц, поэтому пятый день августа в выборку не попадает, хотя в таблице `calendar` есть запись `2016-07-05`.

```mysql
DROP TABLE IF EXISTS temp;
CREATE TEMPORARY TABLE temp (date DATETIME);
SET @N := -1;
INSERT INTO temp SELECT DATE_ADD("2018-08-01", INTERVAL @N := @N + 1  DAY) FROM mysql.help_relation LIMIT 31;

SELECT
    date,
    (SELECT
        EXISTS(
            SELECT created_at
            FROM calendar
            WHERE
                DAYOFMONTH(created_at) = DAYOFMONTH(date)
            AND
                MONTH(created_at) = 8
        )
    ) AS `match`
FROM temp;
```

Альтернативное решение:

```mysql-sql
CREATE TEMPORARY TABLE last_days (day INT);

INSERT INTO last_days VALUES
    (0), (1), (2), (3), (4), (5), (6), (7),
    (8), (9), (10), (11), (12), (13), (14), (15),
    (16), (17), (18), (19), (20), (21), (22), (23),
    (24), (25), (26), (27), (28), (29), (30);

SELECT
    DATE(DATE('2018-08-31') - INTERVAL l.day DAY) AS day,
    NOT ISNULL(c.created_at) AS `match`
FROM last_days AS l
LEFT JOIN calendar AS c
ON DATE(DATE('2018-08-31') - INTERVAL l.day DAY) = p.created_at
ORDER BY day;
```

**4. Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.**

Воспользуемся ранее созданной таблицей `calendar`, в которой есть 6 записей. Для решения, создадим временную таблицу и поместим в неё 5 актуальных записей. Потом очистим исходную таблицу и перезапишем в неё данные из временной.

```mysql
DROP TABLE IF EXISTS temp;

CREATE TEMPORARY TABLE temp (created_at DATETIME);

INSERT INTO temp (
    SELECT *
    FROM calendar
    ORDER BY created_at DESC
    LIMIT 5
);

TRUNCATE TABLE calendar;

INSERT INTO calendar (
    SELECT * FROM temp
);

DROP TABLE temp;
```

Решение с использованием транзакции и динамического запроса:

```mysql-sql
START TRANSACTION;
PREPARE postdel FROM 'DELETE FROM calendar ORDER BY created_at LIMIT ?;'
SET @total = (SELECT COUNT(*) - 5 FROM calendar);
EXECUTE postdel USING @total;
COMMIT;
```

Решение в один запрос:

```mysql-sql
DELETE calendar
FROM calendar
JOIN (
    SELECT created_at
    FROM calendar
    ORDER BY created_at DESC
    LIMIT 5, 1
) AS todel
ON calendar.created_at <= todel.created_at;
```
