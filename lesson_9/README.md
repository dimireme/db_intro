## Урок 9. Оптимизация запросов.

**1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.**

```mysql
DROP FUNCTION IF EXISTS hello;

CREATE FUNCTION hello ()
RETURNS text NOT DETERMINISTIC
BEGIN
	SET @current_hour = HOUR(CURRENT_TIME());
	IF @current_hour <= 6 THEN RETURN "Доброй ночи";
	ELSEIF @current_hour <= 12 THEN RETURN "Доброе утро";
	ELSEIF @current_hour <= 18 THEN RETURN "Добрый день";
	ELSE RETURN "Добрый вечер";
	END IF;
END;

SELECT hello();
```

**2. Создайте SQL-запрос, который помещает в таблицу users миллион записей.**

Сперва подготовим таблицу `products`.

```mysql
DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT "Название продукта",
	description VARCHAR(255) COMMENT "Описание продукта"
) COMMENT "продукты";
```

Добавим триггер на вставку.

```mysql
DROP TRIGGER IF EXISTS check_null_product;

CREATE TRIGGER check_null_product
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
	END IF;
END;
```

Добавим триггер на обновление. Он не быдет вызывать ошибки, но и новые нулевые данные не запишет.

```mysql
DROP TRIGGER IF EXISTS check_null_product_update;

CREATE TRIGGER check_null_product_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SET NEW.name = OLD.name;
		SET NEW.description = OLD.description;
	END IF;
END;
```

Проверим вставку значений.

```mysql
INSERT INTO products (name, description) VALUES
	('prod_1', 'desc_1'),
	(NULL, 'desc_2'),
	('prod_3', NULL);

SELECT * FROM products;
```

| id  | name   | description |
| --- | ------ | ----------- |
| 1   | prod_1 | desc_1      |
| 2   |        | desc_2      |
| 3   | prod_3 |             |

Данные успешно вставились. Посмотрим что будет, если записать оба нулевых значения.

```mysql
INSERT INTO products (name, description) VALUES (NULL, NULL);
```

Запрос выполнится с ошибкой.

```mysql
ERROR 1644 (45000): INSERT canceled
```

Проверим работу триггера на обновление.

```mysql
UPDATE products SET name = NULL WHERE id IN (1, 3);

SELECT * FROM products;
```

| id  | name   | description |
| --- | ------ | ----------- |
| 1   |        | desc_1      |
| 2   |        | desc_2      |
| 3   | prod_3 |             |

Первая строка одновилась, так как не все значения (`name` и `description`) были нулевыми. Третья запись не была обновлена. Запрос не вызвал ошибки. Триггер отработал как и ожидалось.
