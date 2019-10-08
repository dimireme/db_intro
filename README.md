# Lesson 4. Агрегация данных.

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

Подсчитайте средний возраст пользователей в таблице users.

### Решение

Для начала создадим таблицу с пользователями
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

Итоговый запрос:
```mysql
SELECT SUM(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) / COUNT(*) AS average_age FROM user;
-- или
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 2) AS average_age FROM user;
```

### Задание

Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

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
```


### Задание

Подсчитайте произведение чисел в столбце таблицы.

### Решение

```mysql
SOURCE numbers.sql;

SELECT ROUND(EXP(SUM(LOG(value)))) as mul from numbers;
```

<details><summary>Файл numbers.sql</summary>
<p>

```mysql
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (
	value INT COMMENT 'Значение'
) COMMENT = 'Числа для перемножения';

INSERT INTO numbers (value) VALUES (1), (2), (3), (4), (5);
```

</p>
</details>
