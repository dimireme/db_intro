## Урок 3. Операторы, фильтрация, сортировка и ограничение.

**1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.**

```mysql
UPDATE user SET
    created_at = IF(created_at is NULL, NOW(), created_at),
    updated_at = IF(updated_at is NULL, NOW(), updated_at);
```

или

```mysql
UPDATE user SET created_at = NOW() WHERE created_at = NULL;
UPDATE user SET updated_at = NOW() WHERE updated_at = NULL;
```

**2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.**

Создадим таблицу с ошибочными данными.

```mysql
SOURCE user.sql;
```

<details><summary>Файл user.sql</summary>

```mysql
 DROP TABLE IF EXISTS user;
 CREATE TABLE user (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя пользователя',
    birthday_at VARCHAR(255),
    created_at VARCHAR(255),
    updated_at VARCHAR(255)
 ) COMMENT = 'Пользователи';

 INSERT INTO user (name, birthday_at, created_at, updated_at) VALUES
    ('alex', '16 june 1988', '20.10.2017 8:10', '21.10.2017 8:10'),
    ('max', '17 may 1989', '22.10.2017 8:10', '23.10.2017 8:10'),
    ('kate', '18 august 1990', '24.10.2017 8:10', '25.10.2017 8:10');
```

</details>

Исправим записи и переопределим столбцы таблицы

```mysql
UPDATE user SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i');
UPDATE user SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

ALTER TABLE user MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE user MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
```

**3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.**

Подготовим таблицу

```mysql
SOURCE store.sql;
```

<details><summary>Файл store.sql</summary>

```mysql
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
    id SERIAL PRIMARY KEY,
    value INT NOT NULL DEFAULT 0 COMMENT 'Доступное количество'
) COMMENT 'Складские запасы';

INSERT INTO storehouses_products (value) VALUES
    (0),
    (2500),
    (0),
    (30),
    (500),
    (1);
```

</details>

Сделаем запрос

```mysql
SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 1 ELSE 0 END, value;
-- или
SELECT * FROM storehouses_products ORDER BY IF (value > 0, 0, 1), value;
```

**4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august').**

```mysql
SELECT
    id, name, birthday_at
FROM
    user
WHERE (
    birthday_at LIKE '%may%' OR
    birthday_at LIKE '%august%'
);
```

Или

```mysql
SELECT
	id, name, birthday_at
FROM
	user
WHERE
	DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');
```

**5. Из таблицы catalogs извлекаются записи при помощи запроса `SELECT * FROM catalogs WHERE id IN (5, 1, 2);`. Отсортируйте записи в порядке, заданном в списке IN.**

Подготовим данные

```mysql
SOURCE catalogs.sql;
```

<details><summary>Файл catalogs.sql</summary>

```mysql
 DROP TABLE IF EXISTS catalogs;

 CREATE TABLE catalogs (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Наименование товара',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 ) COMMENT = 'Каталог ХХХ';

 INSERT INTO catalogs (name) VALUES
    ('alex_1'),
    ('jessie_2'),
    ('jasmine_3'),
    ('oudrey_4'),
    ('madison_5'),
    ('oletta_6'),
    ('nikole_7');

```

</details>

Запрос:

```mysql
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIND_IN_SET(id, '5,1,2');
-- или
SELECT * FROM catalogs ORDER BY FIELD(id, 5, 1, 2);
```
