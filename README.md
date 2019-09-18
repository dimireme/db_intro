# Lesson 4. Агрегация данных.

Склонировать репозиторий и из папки репозитория запустить mysql сервер: 

```text
git clone https://github.com/dimireme/db_intro.git
cd db_intro
mysql
```

### Задание

Подсчитайте средний возраст пользователей в таблице users.

### Решение

```mysql

```

### Задание

Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

// TODO: доделать 
### Решение

Создадим таблицу с ошибочными данными.

```mysql
SOURCE user.sql;
```

Исправим записи и переопределим столбцы таблицы
```mysql
UPDATE user SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i');
UPDATE user SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
    
ALTER TABLE user MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE user MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
```

<details><summary>Файл user.sql</summary>
<p>

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

</p>
</details>

### Задание

Подсчитайте произведение чисел в столбце таблицы.

### Решение

```mysql
SOURCE store.sql;

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 1 ELSE 0 END, value;
```

<details><summary>Файл store.sql</summary>
<p>

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

</p>
</details>
