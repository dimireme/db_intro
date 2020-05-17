## Урок 9. Оптимизация запросов.

**1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.**

```mysql
DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	record_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(255),
	pk BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255)
) ENGINE ARCHIVE;
```

```mysql
CREATE PROCEDURE log_insert_procedure (
	table_name VARCHAR(255),
	id BIGINT,
	name VARCHAR(255)
)
BEGIN
	INSERT INTO logs (table_name, pk, name) VALUES (table_name, id, name);
END;
```

```mysql
CALL log_insert_procedure('text_table', 42, 'test_name');
```

| record_datetime       | table_name | pk  | name      |
| --------------------- | ---------- | --- | --------- |
| 2020-05-12 00:21:08.0 | text_table | 42  | test_name |

Процедура успешно отработала. Очистим таблицу логов, чтобы избавиться от тестовых данных.

```mysql
TRUNCATE logs;
```

Запрос приведёт к ошибке `ERROR 1031 (HY000): Table storage engine for 'logs' doesn't have this option`. Таблицу с подсистемой хранения `ARCHIVE` очистить нельзя, только пересоздать.

Создадим триггеры для таблиц users, catalogs и products

```mysql
DROP TRIGGER IF EXISTS log_insert_trigger_on_catalogs;
CREATE TRIGGER log_insert_trigger_on_catalogs
AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	CALL log_insert_procedure('catalogs', NEW.id, NEW.name);
END;

DROP TRIGGER IF EXISTS log_insert_trigger_on_users;
CREATE TRIGGER log_insert_trigger_on_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	CALL log_insert_procedure('users', NEW.id, NEW.name);
END;

DROP TRIGGER IF EXISTS log_insert_trigger_on_products;
CREATE TRIGGER log_insert_trigger_on_products
AFTER INSERT ON products
FOR EACH ROW
BEGIN
	CALL log_insert_procedure('products', NEW.id, NEW.name);
END;
```

Очистим таблицы `catalogs`, `users` и `products`. Заполним их тестовыми данными.

```mysql
TRUNCATE catalogs;
TRUNCATE users;
TRUNCATE products;

INSERT INTO catalogs (name) VALUES ('cat_record_1'), ('cat_record_2');
INSERT INTO users (name) VALUES ('users_record_1'), ('users_record_2');
INSERT INTO products (name) VALUES ('prod_record_1'), ('prod_record_2');
```

Посмотрим на результат.

```mysql
SELECT * FROM catalogs;
```

| id  | name         | created_at            | updated_at            |
| --- | ------------ | --------------------- | --------------------- |
| 1   | cat_record_1 | 2020-05-12 00:39:29.0 | 2020-05-12 00:39:29.0 |
| 2   | cat_record_2 | 2020-05-12 00:39:29.0 | 2020-05-12 00:39:29.0 |

```mysql
SELECT * FROM users;
```

| id  | name           | birthday_at | created_at            | updated_at            |
| --- | -------------- | ----------- | --------------------- | --------------------- |
| 1   | users_record_1 |             | 2020-05-12 00:39:31.0 | 2020-05-12 00:39:31.0 |
| 2   | users_record_2 |             | 2020-05-12 00:39:31.0 | 2020-05-12 00:39:31.0 |

```mysql
SELECT * FROM products;
```

| id  | name          | description |
| --- | ------------- | ----------- |
| 1   | prod_record_1 |             |
| 2   | prod_record_2 |             |

```mysql
SELECT * FROM logs;
```

| record_datetime       | table_name | pk  | name           |
| --------------------- | ---------- | --- | -------------- |
| 2020-05-12 00:39:29.0 | catalogs   | 1   | cat_record_1   |
| 2020-05-12 00:39:29.0 | catalogs   | 2   | cat_record_2   |
| 2020-05-12 00:39:31.0 | users      | 1   | users_record_1 |
| 2020-05-12 00:39:31.0 | users      | 2   | users_record_2 |
| 2020-05-12 00:39:35.0 | products   | 1   | prod_record_1  |
| 2020-05-12 00:39:35.0 | products   | 2   | prod_record_2  |

Триггеры работают как и задумывалось.

**2. Создайте SQL-запрос, который помещает в таблицу users миллион записей.**

Создадим тестовую таблицу `test_large` с одним полем `name`.

```mysql
DROP TABLE IF EXISTS test_large;
CREATE TABLE test_large (name VARCHAR(255));
```

Создадим процедуру `set_large` которая добавляет в таблицу `test_large` значения вида `test_name_{i}`, где `i` - порядковый номер записи.

```mysql
DROP PROCEDURE IF EXISTS set_large;
CREATE PROCEDURE set_large (num INT)
BEGIN
	SET @counter := 1;
	WHILE (@counter<=num) DO
		INSERT INTO test_large (name) VALUES (CONCAT('test_name_', @counter));
		SET @counter := @counter + 1;
	END WHILE;
END;
```

Для начала выполним процедуру `set_large` с аргументом 10000.

```mysql
CALL set_large(10000);
```

Запрос выполнялся 55 секунд.

```
SELECT COUNT(*) FROM test_large;
```

| count(\*) |
| --------- |
| 10000     |

Очевидно, что запрос не оптимален.

Создадим временную таблицу `users_temp` и поместим в неё 10 записей.

```mysql
DROP TABLE IF EXISTS users_temp;

CREATE TABLE users_temp (name VARCHAR(255));

INSERT INTO users_temp (name) VALUES
	('Audrey'),
	('Jasmine'),
	('Madison'),
	('Tory'),
	('Adreana'),
	('Oletta'),
	('Jesse'),
	('Nicole'),
	('Sasha'),
	('Alexis')
;
```

Создадим таблицу `users_large` с одним полем `name`. Вставим в неё записи из таблицы `users_temp`, сджойненые 6 раз. В итоге получим 1000000 записей в таблице `users_large`.

```mysql
CREATE TABLE users_large (name VARCHAR(255));

INSERT INTO users_large (name) SELECT fst.name FROM
	users_temp as fst,
	users_temp as snd,
	users_temp as thd,
	users_temp as fth,
	users_temp as fif,
	users_temp as sth
;
```

Проверим результат

```mesql
SELECT COUNT(*) FROM users_large;
```

| COUNT(\*) |
| --------- |
| 1000000   |

Задача выполнена. В конце удалим временную таблицу `users_temp`.

```mysql
DROP TABLE IF EXISTS users_temp;
```
