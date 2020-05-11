## Урок 8. Хранимые процедуры и функции. Триггеры.

**1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".**

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

**2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.**

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

**3. Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.**

| 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8   | 9   | 10  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0   | 1   | 1   | 2   | 3   | 5   | 8   | 13  | 21  | 34  | 55  |

```mysql
DROP FUNCTION IF EXISTS get_nth_fibonachi;
CREATE FUNCTION get_nth_fibonachi (n INT)
RETURNS INT
BEGIN
	DECLARE temp INT;
	SET @curr = 1;
	SET @prev = 1;
	SET @i = 2;
	IF n > 2 THEN
		WHILE @i < n DO
			SET temp = @curr;
			SET @curr = @curr + @prev;
			SET @prev = temp;
			SET @i = @i + 1;
		END WHILE;
	END IF;
	RETURN @curr;
END;
```

```mysql
SELECT get_nth_fibonachi(10); # 55
SELECT get_nth_fibonachi(46); # 1 836 311 903
SELECT get_nth_fibonachi(47); # ERROR 1264 (22003): Out of range value for column 'get_nth_fibonachi(47)' at row 1
```
