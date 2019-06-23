# Lesson 1. Язык запросов SQL.

## Part 1

Склонировать репозиторий и из папки репозитория запустить mysql сервер: 

```text
git clone https://github.com/dimireme/db_intro.git
cd db_intro
mysql
```

### Задание

Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.

### Решение

```mysql
SOURCE example.sql;
DESCRIBE example.users;
```

<details><summary>Файл example.sql</summary>
<p>

```mysql
DROP DATABASE IF EXISTS example;
CREATE DATABASE example;

DROP TABLE IF EXISTS example.users;
CREATE TABLE example.users (
	id INT PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя пользователя'
) COMMENT = 'Пользователи';
```

</p>
</details>

### Задание

Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
 
### Решение

В среде mysql выполнить команды

```mysql
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
EXIT;
```

В папке проекта выполнить

```text
mysqldump example > example_dump.sql
mysql sample < example_dump.sql
mysql
```

В среде mysql

```mysql
SHOW TABLES FROM sample;
DESCRIBE sample.users; 
```

<details><summary>Файл example_dump.sql</summary>
<p>

```mysql
-- MySQL dump 10.13  Distrib 5.7.26, for Linux (x86_64)
--
-- Host: localhost    Database: example
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-11  1:04:14
```

</p>
</details>

### Задание

Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.

### Решение

Выйти из среды mysql:

```mysql
EXIT;
```

Создать дамп таблицы:

```text
mysqldump --skip-opt  --where="1 LIMIT 100" mysql help_keyword > help_keyword_dump.sql
```

<details><summary>Файл help_keyword_dump.sql</summary>
<p>

```mysql
-- MySQL dump 10.13  Distrib 5.7.26, for Linux (x86_64)
--
-- Host: localhost    Database: mysql
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.18.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `help_keyword`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int(10) unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_keyword`
--
-- WHERE:  1 LIMIT 100

INSERT INTO `help_keyword` VALUES (0,'(JSON');
INSERT INTO `help_keyword` VALUES (1,'->');
INSERT INTO `help_keyword` VALUES (2,'->>');
INSERT INTO `help_keyword` VALUES (3,'<>');
INSERT INTO `help_keyword` VALUES (4,'ACCOUNT');
INSERT INTO `help_keyword` VALUES (5,'ACTION');
INSERT INTO `help_keyword` VALUES (6,'ADD');
INSERT INTO `help_keyword` VALUES (7,'AES_DECRYPT');
INSERT INTO `help_keyword` VALUES (8,'AES_ENCRYPT');
INSERT INTO `help_keyword` VALUES (9,'AFTER');
INSERT INTO `help_keyword` VALUES (10,'AGAINST');
INSERT INTO `help_keyword` VALUES (11,'AGGREGATE');
INSERT INTO `help_keyword` VALUES (12,'ALGORITHM');
INSERT INTO `help_keyword` VALUES (13,'ALL');
INSERT INTO `help_keyword` VALUES (14,'ALTER');
INSERT INTO `help_keyword` VALUES (15,'ANALYSE');
INSERT INTO `help_keyword` VALUES (16,'ANALYZE');
INSERT INTO `help_keyword` VALUES (17,'AND');
INSERT INTO `help_keyword` VALUES (18,'ANY_VALUE');
INSERT INTO `help_keyword` VALUES (19,'ARCHIVE');
INSERT INTO `help_keyword` VALUES (20,'AREA');
INSERT INTO `help_keyword` VALUES (21,'AS');
INSERT INTO `help_keyword` VALUES (22,'ASBINARY');
INSERT INTO `help_keyword` VALUES (23,'ASC');
INSERT INTO `help_keyword` VALUES (24,'ASTEXT');
INSERT INTO `help_keyword` VALUES (25,'ASWKB');
INSERT INTO `help_keyword` VALUES (26,'ASWKT');
INSERT INTO `help_keyword` VALUES (27,'AT');
INSERT INTO `help_keyword` VALUES (28,'AUTOCOMMIT');
INSERT INTO `help_keyword` VALUES (29,'AUTOEXTEND_SIZE');
INSERT INTO `help_keyword` VALUES (30,'AUTO_INCREMENT');
INSERT INTO `help_keyword` VALUES (31,'AVG_ROW_LENGTH');
INSERT INTO `help_keyword` VALUES (32,'BEFORE');
INSERT INTO `help_keyword` VALUES (33,'BEGIN');
INSERT INTO `help_keyword` VALUES (34,'BETWEEN');
INSERT INTO `help_keyword` VALUES (35,'BIGINT');
INSERT INTO `help_keyword` VALUES (36,'BINARY');
INSERT INTO `help_keyword` VALUES (37,'BINLOG');
INSERT INTO `help_keyword` VALUES (38,'BOOL');
INSERT INTO `help_keyword` VALUES (39,'BOOLEAN');
INSERT INTO `help_keyword` VALUES (40,'BOTH');
INSERT INTO `help_keyword` VALUES (41,'BTREE');
INSERT INTO `help_keyword` VALUES (42,'BUFFER');
INSERT INTO `help_keyword` VALUES (43,'BY');
INSERT INTO `help_keyword` VALUES (44,'BYTE');
INSERT INTO `help_keyword` VALUES (45,'CACHE');
INSERT INTO `help_keyword` VALUES (46,'CALL');
INSERT INTO `help_keyword` VALUES (47,'CASCADE');
INSERT INTO `help_keyword` VALUES (48,'CASE');
INSERT INTO `help_keyword` VALUES (49,'CATALOG_NAME');
INSERT INTO `help_keyword` VALUES (50,'CEIL');
INSERT INTO `help_keyword` VALUES (51,'CEILING');
INSERT INTO `help_keyword` VALUES (52,'CENTROID');
INSERT INTO `help_keyword` VALUES (53,'CHAIN');
INSERT INTO `help_keyword` VALUES (54,'CHANGE');
INSERT INTO `help_keyword` VALUES (55,'CHANNEL');
INSERT INTO `help_keyword` VALUES (56,'CHAR');
INSERT INTO `help_keyword` VALUES (57,'CHARACTER');
INSERT INTO `help_keyword` VALUES (58,'CHARSET');
INSERT INTO `help_keyword` VALUES (59,'CHECK');
INSERT INTO `help_keyword` VALUES (60,'CHECKSUM');
INSERT INTO `help_keyword` VALUES (61,'CIPHER');
INSERT INTO `help_keyword` VALUES (62,'CLASS_ORIGIN');
INSERT INTO `help_keyword` VALUES (63,'CLIENT');
INSERT INTO `help_keyword` VALUES (64,'CLOSE');
INSERT INTO `help_keyword` VALUES (65,'COALESCE');
INSERT INTO `help_keyword` VALUES (66,'CODE');
INSERT INTO `help_keyword` VALUES (67,'COLLATE');
INSERT INTO `help_keyword` VALUES (68,'COLLATION');
INSERT INTO `help_keyword` VALUES (69,'COLUMN');
INSERT INTO `help_keyword` VALUES (70,'COLUMNS');
INSERT INTO `help_keyword` VALUES (71,'COLUMN_NAME');
INSERT INTO `help_keyword` VALUES (72,'COMMENT');
INSERT INTO `help_keyword` VALUES (73,'COMMIT');
INSERT INTO `help_keyword` VALUES (74,'COMMITTED');
INSERT INTO `help_keyword` VALUES (75,'COMPACT');
INSERT INTO `help_keyword` VALUES (76,'COMPLETION');
INSERT INTO `help_keyword` VALUES (77,'COMPRESSED');
INSERT INTO `help_keyword` VALUES (78,'COMPRESSION');
INSERT INTO `help_keyword` VALUES (79,'CONCURRENT');
INSERT INTO `help_keyword` VALUES (80,'CONDITION');
INSERT INTO `help_keyword` VALUES (81,'CONNECTION');
INSERT INTO `help_keyword` VALUES (82,'CONSISTENT');
INSERT INTO `help_keyword` VALUES (83,'CONSTRAINT');
INSERT INTO `help_keyword` VALUES (84,'CONSTRAINT_CATALOG');
INSERT INTO `help_keyword` VALUES (85,'CONSTRAINT_NAME');
INSERT INTO `help_keyword` VALUES (86,'CONSTRAINT_SCHEMA');
INSERT INTO `help_keyword` VALUES (87,'CONTAINS');
INSERT INTO `help_keyword` VALUES (88,'CONTINUE');
INSERT INTO `help_keyword` VALUES (89,'CONVERT');
INSERT INTO `help_keyword` VALUES (90,'CONVEXHULL');
INSERT INTO `help_keyword` VALUES (91,'COUNT');
INSERT INTO `help_keyword` VALUES (92,'CREATE');
INSERT INTO `help_keyword` VALUES (93,'CREATE_DH_PARAMETERS');
INSERT INTO `help_keyword` VALUES (94,'CROSS');
INSERT INTO `help_keyword` VALUES (95,'CROSSES');
INSERT INTO `help_keyword` VALUES (96,'CSV');
INSERT INTO `help_keyword` VALUES (97,'CURRENT_USER');
INSERT INTO `help_keyword` VALUES (98,'CURSOR');
INSERT INTO `help_keyword` VALUES (99,'CURSOR_NAME');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-23 22:08:52
```

</p>
</details>

## Part 2

### Задание

Пусть в таблице catalogs базы данных shop в строке name могут находиться пустые строки и поля принимающие значение NULL. Напишите запрос, который заменяет все такие поля на строку ‘empty’. Помните, что на уроке мы установили уникальность на поле name. Возможно ли оставить это условие? Почему?

### Решение

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

### Задание

Спроектируйте базу данных, которая позволяла бы организовать хранение медиа-файлов, загружаемых пользователем (фото, аудио, видео). Сами файлы будут храниться в файловой системе, а база данных будет хранить только пути к файлам, названия, описания, ключевых слов и принадлежности пользователю.

### Решение

В среде mysql:

```mysql
DROP DATABASE IF EXISTS media ;
CREATE DATABASE media CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE media;
SOURCE media.sql
```

<details><summary>Файл media.sql</summary>
<p>

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

</p>
</details>

### Задание

В учебной базе данных shop присутствует таблица catalogs. Пусть в базе данных sample имеется таблица cat, в которой могут присутствовать строки с такими же первичными ключами. Напишите запрос, который копирует данные из таблицы catalogs в таблицу cat, при этом для записей с конфликтующими первичными ключами в таблице cat должна производиться замена значениями из таблицы catalogs.

### Решене

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
