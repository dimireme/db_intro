# Lesson 5. Сложные запросы.

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

Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

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

Выведите список товаров products и разделов catalogs, который соответствует товару.

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

Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
Поля from, to и label содержат английские названия городов, поле name — русское. 
Выведите список рейсов flights с русскими названиями городов.

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
