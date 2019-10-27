# Lesson 6. Транзакции, переменные, представления.

Склонировать репозиторий и из папки репозитория запустить mysql сервер: 

```text
git clone https://github.com/dimireme/db_intro.git
cd db_intro
mysql
```

### Задание

В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

### Решение

Создадим базы данных и таблицы. Заполним таблицу `shop.users` тестовыми данными. Таблицу `sample.users` оставим пустой.

```mysql
SOURCE example.sql;
```

<details><summary>Файл example.sql</summary>
<p>

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

</p>
</details>

Итоговые запросы:
```mysql
START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE id = 1);
DELETE FROM shop.users * WHERE id = 1;
COMMIT;
```

### Задание

Создайте представление, которое выводит название name товарной позиции 
из таблицы products и соответствующее название каталога name из таблицы catalogs.

### Решение

Создадим базу данных `shop` и таблицы `products` и `catalogs`. Заполним их тестовыми данными.

```mysql
SOURCE shop.sql;
```

<details><summary>Файл shop.sql</summary>
<p>

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

</p>
</details>

Создадим представление `v1`:

```mysql
CREATE OR REPLACE VIEW v1 AS 
SELECT 
    p.name as product, 
    c.name as catalog 
FROM 
    products as p 
LEFT JOIN 
    catalogs as c 
ON p.catalog_id = c.id;

SELECT * FROM v1;
```

### Задание

Пусть имеется таблица с календарным полем created_at. 
В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', 
'2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный 
список дат за август, выставляя в соседнем поле значение 1, если дата присутствует
в исходном таблице и 0, если она отсутствует.

### Решение

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

Для решения задачи сперва создадим временную таблицу `temp` и заполним её всеми датами августа. Год не имеет значения. Далее делаем запрос к временной таблицы. Вторым столбцом отмечаем, подходит ли дата к условию или нет. В подзапросе используется ключевое слово `EXISTS`, поэтому дата `2018-08-16` учитывается только один раз, хотя присутствует в таблице `calendar` дважды. Также в WHERE-условии отфильтровываем только восьмой месяц, поэтому пятый день августа в выборку не попадает, хотя в таблице `calendar` есть запись `2016-07-05`.

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

### Задание

Пусть имеется любая таблица с календарным полем created_at. 
Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

### Решение

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
