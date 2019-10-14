# Lesson 6. Транзакции, переменные, представления.

Склонировать репозиторий и из папки репозитория запустить mysql сервер: 

```text
git clone https://github.com/dimireme/db_intro.git
cd db_intro
mysql
```

```mysql
USE example;
```

### Задание

В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

### Решение

// TODO: FIX THIS

Создадим таблицу с пользователями
```mysql
SOURCE user.sql;
```

<details><summary>Файл user.sql</summary>
<p>

```mysql
 DROP TABLE IF EXISTS user;
 CREATE TABLE user (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя пользователя',
    birthday_at DATE
 ) COMMENT = 'Пользователи';

 INSERT INTO user (name, birthday_at) VALUES
    ('oletta', '1990-10-05'),
    ('jasmine', '1984-11-12'),
    ('joni', '1985-05-20'),
    ('jesse', '1988-02-14'),
    ('madison', '1998-01-12'),
    ('audrey', '2006-08-29');
```

</p>
</details>

Итоговый запрос:
```mysql
SELECT SUM(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) / COUNT(*) AS average_age FROM user;
-- или
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 2) AS average_age FROM user;
```

### Задание

Создайте представление, которое выводит название name товарной позиции 
из таблицы products и соответствующее название каталога name из таблицы catalogs.

### Решение

Воспользуемся ранее созданной таблицей `user`.

```mysql
SELECT 
	COUNT(*) AS total, 
	WEEKDAY(
		CONCAT(
			YEAR(NOW()),
			SUBSTR(birthday_at, 5)
		)
	) AS week_day
FROM 
	user 	
GROUP BY 
	week_day;

-- или

SELECT 
	COUNT(*) AS total,
	DATE_FORMAT(
		DATE(
		    CONCAT_WS(
		        '-', 
		        YEAR(NOW()), 
		        MONTH(birthday_at), 
		        DAY(birthday_at)
			)
		),
	    '%W'
	)AS week_day 
FROM user
GROUP BY 
	week_day;
```


### Задание

Пусть имеется таблица с календарным полем created_at. 
В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', 
'2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный 
список дат за август, выставляя в соседнем поле значение 1, если дата присутствует
в исходном таблице и 0, если она отсутствует.

### Решение

```mysql
SOURCE timetable.sql;

SELECT
	id,
	(SELECT name FROM cities WHERE `label` = `from`) AS 'from',
	(SELECT name FROM cities WHERE `label` = `to`) AS 'to' 
FROM flights;

```

<details><summary>Файл timetable.sql</summary>
<p>

```mysql
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

</p>
</details>



### Задание

Пусть имеется любая таблица с календарным полем created_at. 
Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

### Решение

```mysql
SOURCE timetable.sql;

SELECT
	id,
	(SELECT name FROM cities WHERE `label` = `from`) AS 'from',
	(SELECT name FROM cities WHERE `label` = `to`) AS 'to' 
FROM flights;

```

<details><summary>Файл timetable.sql</summary>
<p>

```mysql
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

</p>
</details>
