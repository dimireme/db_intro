DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя покупателя',
	birthday_at DATE COMMENT 'Дата рождения',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
	('Геннадий', '1990-10-05'),
	('Наталья', '1984-11-12'),
	('Александр', '1985-05-20'),
	('Сергей', '1988-02-14'),
	('Иван', '1998-01-12'),
	('Мария', '1992-08-29');


DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя покупателя',
	birthday_at DATE COMMENT 'Дата рождения',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

