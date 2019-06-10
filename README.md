# Lesson 1

##Part 1
Сперва нужно склонировать репозиторий и из папки репозитория запустить mysql сервер: 
```text
git clone https://github.com/dimireme/db_intro.git
cd db_intro
mysql
```
###Задание
Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
###Решение
```mysql
SOURCE example.sql;
DESCRIBE example.users;
```
Код файла example.sql
```mysql
DROP DATABASE IF EXISTS example;
CREATE DATABASE example;

DROP TABLE IF EXISTS example.users;
CREATE TABLE example.users (
	id INT PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя пользователя'
) COMMENT = 'Пользователи';
```

###Задание
 Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
###Решение
В среде mysql выполнить команды
```mysql
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
EXIT;
```
В папке проекта выполнить
```text
mysqldump example > example_dump.sql
mysql example_dump.sql > sample
mysql sample < example_dump.sql
mysql
```
В среде mysql
```mysql
SHOW TABLES FROM sample;
DESCRIBE sample.users; 
```

###Задание
Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
###Решение
Выйти из среды mysql:
```mysql
EXIT;
```
Создать дамп таблицы:
```text
mysqldump --where="1 LIMIT 100" mysql help_keyword > help_keyword_dump.sql
```

##Part 2

###Задание
Пусть в таблице catalogs базы данных shop в строке name могут находиться пустые строки и поля принимающие значение NULL. Напишите запрос, который заменяет все такие поля на строку ‘empty’. Помните, что на уроке мы установили уникальность на поле name. Возможно ли оставить это условие? Почему?
###Решение
В среде mysql выполнить команды:
```mysql
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;
SOURCE shop.sql
UPDATE catalogs SET name = 'empty' WHERE name is NULL;
```
Получим ошибку, так как поле name должно быть уникальным. Решение - убрать уникальный ключ, задать значение по-умолчанию и произвести замену существующих нулевых значений на значение по-умолчанию.
```mysql
ALTER TABLE catalogs ALTER name SET DEFAULT 'empty', DROP INDEX unique_name;
UPDATE catalogs SET name = 'empty' WHERE name is NULL;
```



###Задание
Спроектируйте базу данных, которая позволяла бы организовать хранение медиа-файлов, загружаемых пользователем (фото, аудио, видео). Сами файлы будут храниться в файловой системе, а база данных будет хранить только пути к файлам, названия, описания, ключевых слов и принадлежности пользователю.
###Решение


###Задание
В учебной базе данных shop присутствует таблица catalogs. Пусть в базе данных sample имеется таблица cat, в которой могут присутствовать строки с такими же первичными ключами. Напишите запрос, который копирует данные из таблицы catalogs в таблицу cat, при этом для записей с конфликтующими первичными ключами в таблице cat должна производиться замена значениями из таблицы catalogs.
###Решене