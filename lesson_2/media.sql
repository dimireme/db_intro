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
