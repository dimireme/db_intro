## Урок 5. Сложные запросы.

**1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.**

Создадим базу данных `shop` с таблицами `catalogs`, `users`, `products`, `orders` и `orders_products`. Заполним таблицы тестовыми данными.

```mysql
SOURCE shop.sql;
```

<details><summary>Файл shop.sql</summary>

```mysql
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
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

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY fk_user_id (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'Заказы';

INSERT INTO orders
	(user_id)
VALUES
	(1),
	(2),
	(2),
	(4);


DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
	id SERIAL PRIMARY KEY,
	order_id BIGINT UNSIGNED,
	product_id BIGINT UNSIGNED,
	total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY fk_order_id (order_id) REFERENCES orders (id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY fk_product_id (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'Состав заказа';

INSERT INTO orders_products
	(order_id, product_id)
VALUES
	(1, 2),
	(1, 3),
	(2, 1),
	(2, 2),
	(2, 3),
	(3, 5),
	(4, 6),
	(4, 2);
```

</details>

Итоговый запрос:

```mysql
SELECT id, name
FROM users
WHERE id IN (
	SELECT DISTINCT user_id
	FROM orders
);
```

То же самое с помощью JOIN-запроса:

```mysql
SELECT DISTINCT
	u.id, u.name
FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
;
```

**2. Выведите список товаров `products` и разделов `catalogs`, который соответствует товару.**

```mysql
SELECT p.id, p.name, c.name
FROM products AS p
LEFT JOIN catalogs AS c
ON p.catalog_id = c.id
;
```

то же самое, с использованием вложенных запросов:

```mysql
SELECT
	id,
	name,
	(SELECT name FROM catalogs WHERE catalog_id = id) as 'catalog'
FROM products;
```

Вложенный подзапрос - коррелируемый и выполнится для каждой строки запроса. Поэтому предпочтительнее использовать JOIN-запрос.
В этом задании используем LEFT JOIN, так как не для всех записей таблицы `products` может существовать запись в таблице `catalogs`.

**3. Пусть имеется таблица рейсов `flights` (`id`, `from`, `to`) и таблица городов `cities` (`label`, `name`). Поля `from`, `to` и `label` содержат английские названия городов, поле `name` — русское. Выведите список рейсов `flights` с русскими названиями городов.**

Создадим таблицу `timetable`.

```mysql
SOURCE timetable.sql;
```

<details><summary>Файл timetable.sql</summary>

```mysql
DROP DATABASE IF EXISTS example;
CREATE DATABASE example CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE example;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	`from` VARCHAR(255),
	`to` VARCHAR(255)
) COMMENT = 'Список маршрутов';

INSERT INTO flights (`from`, `to`) VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	`label` VARCHAR(255),
	name VARCHAR(255)
) COMMENT = 'Лейблы городов';

INSERT INTO cities (`label`, name) VALUES
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'),
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');
```

</details>

Запрос:

```mysql
SELECT
	f.id,
	cities_from.name AS `from`,
	cities_to.name AS `to`
FROM flights AS f
LEFT JOIN cities AS cities_from
ON f.from = cities_from.label
LEFT JOIN cities AS cities_to
ON f.to = cities_to.label
;
```

То же самое с вложенными запросами:

```mysql
SELECT
	id,
	(SELECT name FROM cities WHERE `label` = `from`) AS 'from',
	(SELECT name FROM cities WHERE `label` = `to`) AS 'to'
FROM flights;
```
