DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя пользователя'
) COMMENT = 'Пользователи';

DROP TABLE IF EXISTS paths;
CREATE TABLE paths (
	id SERIAL PRIMARY KEY,
	path VARCHAR(255) COMMENT 'Директория'
) COMMENT = 'Директории';

DROP TABLE IF EXISTS keywords;
CREATE TABLE keywords (
	id SERIAL PRIMARY KEY,
	keyword VARCHAR(255) COMMENT 'Ключевое слово'
) COMMENT = 'Список ключевых слов';

DROP TABLE IF EXISTS files;
CREATE TABLE files (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название файла',
	path_id INT UNSIGNED,
	user_id INT UNSIGNED
) COMMENT = 'Медиа файлы';

DROP TABLE IF EXISTS file_keywords;
CREATE TABLE file_keywords (
    id SERIAL PRIMARY KEY,
	file_id INT UNSIGNED,
	keyword_id INT UNSIGNED
) COMMENT = 'Связь файлов и ключеывых слов';
