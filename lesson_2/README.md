## Урок 2. Язык запросов SQL.

**1. Пусть в таблице catalogs базы данных shop в строке name могут находиться пустые строки и поля принимающие значение NULL. Напишите запрос, который заменяет все такие поля на строку ‘empty’. Помните, что на уроке мы установили уникальность на поле name. Возможно ли оставить это условие? Почему?**

В среде mysql выполнить команды:

```mysql
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shop;
SOURCE shop.sql;
UPDATE catalogs SET name = 'empty' WHERE name IS NULL;
```

Получим ошибку, так как поле name должно быть уникальным. Решение - убрать уникальный ключ, задать значение по-умолчанию и произвести замену существующих нулевых значений на значение по-умолчанию.

```mysql
ALTER TABLE catalogs ALTER name SET DEFAULT 'empty', DROP INDEX unique_name;
UPDATE catalogs SET name = 'empty' WHERE name = '' OR name is NULL;
```

**2. Спроектируйте базу данных, которая позволяла бы организовать хранение медиа-файлов, загружаемых пользователем (фото, аудио, видео). Сами файлы будут храниться в файловой системе, а база данных будет хранить только пути к файлам, названия, описания, ключевых слов и принадлежности пользователю.**

В среде mysql:

```mysql
DROP DATABASE IF EXISTS media ;
CREATE DATABASE media CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE media;
SOURCE media.sql
```

<details><summary>Файл media.sql</summary>

```mysql
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Пользователи';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id SERIAL PRIMARY KEY,
	alias VARCHAR(255) COMMENT 'Псевдоним',
	name VARCHAR(255) COMMENT 'Описание медиа-типов: изображение, аудио, видео',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Типы медиа-файлов';

INSERT INTO media_types VALUES
    (NULL, 'image', 'Изображения', DEFAULT, DEFAULT),
    (NULL, 'audio', 'Аудио-файлы', DEFAULT, DEFAULT),
    (NULL, 'video', 'Видео', DEFAULT, DEFAULT);

DROP TABLE IF EXISTS medias;
CREATE TABLE medias (
	id SERIAL PRIMARY KEY,
	media_type_id INT,
	user_id INT,
	filename VARCHAR(255) COMMENT 'Название файла',
	filesize INT COMMENT 'Размер файла',
	-- metadata JSON COMMENT 'Метаинформация',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX index_of_user_id(user_id),
	INDEX index_of_media_type_id(media_type_id)
) COMMENT = 'Медиа файлы';

DROP TABLE IF EXISTS metadata;
CREATE TABLE metadata (
	id SERIAL PRIMARY KEY,
	media_type_id INT,
	description TEXT COMMENT 'Описание',
	duration INT COMMENT 'Длительность видео или аудио в секундах',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX index_of_media_type_id(media_type_id)
) COMMENT = 'Мета информация';
```

</details>

**3. В учебной базе данных shop присутствует таблица catalogs. Пусть в базе данных sample имеется таблица cat, в которой могут присутствовать строки с такими же первичными ключами. Напишите запрос, который копирует данные из таблицы catalogs в таблицу cat, при этом для записей с конфликтующими первичными ключами в таблице cat должна производиться замена значениями из таблицы catalogs.**

Подготовим таблицу cat:

```mysql
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sample;
CREATE TABLE cat (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название раздела',
	UNIQUE unique_name(name(10))   -- индекс по первым 10 символам
) COMMENT = 'Разделы интернет-магазина';
INSERT INTO cat VALUES (NULL, 'Intell');

DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shop;
SOURCE shop.sql;
```

Команда репликации:

```mysql
REPLACE INTO sample.cat SELECT * FROM shop.catalogs;
```

Альтернативное решение:

```mysql
INSERT INTO
    sample.cat
SELECT
    id, name
FROM
    shop.catalogs
ON DUPLICATE KEY UPDATE
    name = VALUES(name);
```
