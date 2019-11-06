# Lesson 7. Администрирование MySQL

### Задание

Создайте двух пользователей которые имеют доступ к базе данных shop. 
Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
второму пользователю shop — любые операции в пределах базы данных shop.

### Решение



### Задание

Пусть имеется таблица accounts содержащая три столбца id, name, password, 
содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username
таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, 
который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

### Решение



### Пример файла my.cnf и настройки репликации.

файл находится по адресу `/etc/mysql/my.cnf`

```text
[mysqld]
# do not request user and password
# skip-grand-tables

# allow only connections from localhost
bind-address = 127.0.0.1

# redefine default port 3306 -> 3308
port = 3308

# redefine size of temp tables
tmp_table_size = 32M

# switch on log for all queries
general_log = ON

# switch on log for slow queries
slow_query_log = ON

# redefine time of long queries 10s -> 5s
long_query_time = 5

# write log to the tables FILE -> TABLE
log_output = TABLE

# enable log of bin files (requests that change data)
# also add id to server for server could to start
log_bin = ON
sever-id = 1
```

Пример настройки с применением репликаций и утилиты `mysqld_multi`:
```text
[mysqld]
bind-address = 127.0.0.1

[mysqld1]
socket = /tmp/mysql.sock1
port = 3306
pid-file = /usr/local/var/mysql1/mysqld1.pid
datadir = /usr/local/var/mysql1

server-id = 1

# base names for bin journals
log-bin = master-bin
log-bin-index = master-bin.index



[mysqld2]
socket = /tmp/mysql.sock2
port = 3307
pid-file = /usr/local/var/mysql2/mysqld2.pid
datadir = /usr/local/var/mysql2

server-id = 2

# base names for translation journals
relay-log = slave-relay-bin
relay-log-index = slave-relay-bin.index
```

В этом примере первый сервер - master, второй - slave. 

Чтобы всё заработало, подключаемся к master-серверу
```text
mysql --socket=/tmp/mysql.sock1 -u root
```

и создаём специального пользователя

```mysql
CREATE USER repl_user;
GRANT REPLICATION SLAVE ON *.* TO repl_user IDENTIFIED BY '321321';
```

Далее заходим на slave-сервер

```text
mysql --socket=/tmp/mysql.sock2 -u root
```

и настраиваем репликацию

```mysql
CHANGE MASTER TO
    MASTER_HOST = 'localhost',
    MASTER_PORT = 3306,
    MASTER_USER = 'repl_user',
    MASTER_PASSWORD = '321321';
```

Запускаем репликацию:

```mysql
START SLAVE;
```

Проверяем:

```mysql
SHOW SLAVE STATUS\G
```

Потоки репликаций `Slave_IO_Running` и `Slave_SQL_Running` должны быть в статусе `YES`. Значение `SQL_Delay` показывает, на сколько slave-сервер отстаёт от master-сервера.
