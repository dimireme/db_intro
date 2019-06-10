# Lesson 1

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
mysqldump --where="1 LIMIT 100" mysql help_keyword > help_keyword_dump.sql
```

<details><summary>Файл help_keyword_dump.sql</summary>
<p>

```mysql
-- MySQL dump 10.13  Distrib 5.7.26, for Linux (x86_64)
--
-- Host: localhost    Database: mysql
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
-- Table structure for table `help_keyword`
--

DROP TABLE IF EXISTS `help_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int(10) unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 COMMENT='help keywords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_keyword`
--
-- WHERE:  1 LIMIT 100

LOCK TABLES `help_keyword` WRITE;
/*!40000 ALTER TABLE `help_keyword` DISABLE KEYS */;
INSERT INTO `help_keyword` VALUES (0,'(JSON'),(1,'->'),(2,'->>'),(3,'<>'),(4,'ACCOUNT'),(5,'ACTION'),(6,'ADD'),(7,'AES_DECRYPT'),(8,'AES_ENCRYPT'),(9,'AFTER'),(10,'AGAINST'),(11,'AGGREGATE'),(12,'ALGORITHM'),(13,'ALL'),(14,'ALTER'),(15,'ANALYSE'),(16,'ANALYZE'),(17,'AND'),(18,'ANY_VALUE'),(19,'ARCHIVE'),(20,'AREA'),(21,'AS'),(22,'ASBINARY'),(23,'ASC'),(24,'ASTEXT'),(25,'ASWKB'),(26,'ASWKT'),(27,'AT'),(28,'AUTOCOMMIT'),(29,'AUTOEXTEND_SIZE'),(30,'AUTO_INCREMENT'),(31,'AVG_ROW_LENGTH'),(32,'BEFORE'),(33,'BEGIN'),(34,'BETWEEN'),(35,'BIGINT'),(36,'BINARY'),(37,'BINLOG'),(38,'BOOL'),(39,'BOOLEAN'),(40,'BOTH'),(41,'BTREE'),(42,'BUFFER'),(43,'BY'),(44,'BYTE'),(45,'CACHE'),(46,'CALL'),(47,'CASCADE'),(48,'CASE'),(49,'CATALOG_NAME'),(50,'CEIL'),(51,'CEILING'),(52,'CENTROID'),(53,'CHAIN'),(54,'CHANGE'),(55,'CHANNEL'),(56,'CHAR'),(57,'CHARACTER'),(58,'CHARSET'),(59,'CHECK'),(60,'CHECKSUM'),(61,'CIPHER'),(62,'CLASS_ORIGIN'),(63,'CLIENT'),(64,'CLOSE'),(65,'COALESCE'),(66,'CODE'),(67,'COLLATE'),(68,'COLLATION'),(69,'COLUMN'),(70,'COLUMNS'),(71,'COLUMN_NAME'),(72,'COMMENT'),(73,'COMMIT'),(74,'COMMITTED'),(75,'COMPACT'),(76,'COMPLETION'),(77,'COMPRESSED'),(78,'COMPRESSION'),(79,'CONCURRENT'),(80,'CONDITION'),(81,'CONNECTION'),(82,'CONSISTENT'),(83,'CONSTRAINT'),(84,'CONSTRAINT_CATALOG'),(85,'CONSTRAINT_NAME'),(86,'CONSTRAINT_SCHEMA'),(87,'CONTAINS'),(88,'CONTINUE'),(89,'CONVERT'),(90,'CONVEXHULL'),(91,'COUNT'),(92,'CREATE'),(93,'CREATE_DH_PARAMETERS'),(94,'CROSS'),(95,'CROSSES'),(96,'CSV'),(97,'CURRENT_USER'),(98,'CURSOR'),(99,'CURSOR_NAME');
/*!40000 ALTER TABLE `help_keyword` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-11  2:30:30
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
UPDATE catalogs SET name = 'empty' WHERE name is NULL;
```

Получим ошибку, так как поле name должно быть уникальным. Решение - убрать уникальный ключ, задать значение по-умолчанию и произвести замену существующих нулевых значений на значение по-умолчанию.

```mysql
ALTER TABLE catalogs ALTER name SET DEFAULT 'empty', DROP INDEX unique_name;
UPDATE catalogs SET name = 'empty' WHERE name is NULL;
```

### Задание

Спроектируйте базу данных, которая позволяла бы организовать хранение медиа-файлов, загружаемых пользователем (фото, аудио, видео). Сами файлы будут храниться в файловой системе, а база данных будет хранить только пути к файлам, названия, описания, ключевых слов и принадлежности пользователю.

### Решение

В среде mysql:

```mysql
DROP DATABASE IF EXISTS media;
CREATE DATABASE media;
USE media;
SOURCE media.sql
```

<details><summary>Файл media.sql</summary>
<p>

```mysql
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
