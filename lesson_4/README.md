## Урок 4. Агрегация данных.

**1. Подсчитайте средний возраст пользователей в таблице users.**

Для начала создадим таблицу с пользователями

```mysql
SOURCE user.sql;
```

<details><summary>Файл user.sql</summary>

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

</details>

Итоговый запрос:

```mysql
SELECT SUM(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) / COUNT(*) AS average_age FROM user;
-- или
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 2) AS average_age FROM user;
```

**2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.**

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
```

Или

```mysql
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
	) AS week_day
FROM user
GROUP BY
	week_day;
```

**3.Подсчитайте произведение чисел в столбце таблицы.**

```mysql
SOURCE numbers.sql;

SELECT ROUND(EXP(SUM(LOG(value)))) as mul from numbers;
```

<details><summary>Файл numbers.sql</summary>

```mysql
DROP TABLE IF EXISTS numbers;

CREATE TABLE numbers (
	value INT COMMENT 'Значение'
) COMMENT = 'Числа для перемножения';

INSERT INTO numbers (value) VALUES (1), (2), (3), (4), (5);
```

</details>
