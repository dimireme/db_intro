## Урок 10. NoSQL.

**1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.**

```
127.0.0.1:6379> SET '127.0.0.1' 12
OK
127.0.0.1:6379> GET '127.0.0.1'
"12"
127.0.0.1:6379> INCR '127.0.0.1'
(integer) 13
127.0.0.1:6379> GET '127.0.0.1'
"13"
```

или

```
127.0.0.1:6379> INCR '127.0.0.1'
(integer) 14
127.0.0.1:6379> INCR '127.0.0.2'
(integer) 1
127.0.0.1:6379> KEYS *
1) "127.0.0.2"
2) "127.0.0.1"
127.0.0.1:6379> GET '127.0.0.2'
"1"
```

Быстрее будет, если использовать хэши.

```
127.0.0.1:6379> HINCRBY addresses '127.0.0.1' 1
(integer) 1
127.0.0.1:6379> HINCRBY addresses '127.0.0.1' 1
(integer) 2
127.0.0.1:6379> HGET addresses '127.0.0.1'
"2"
127.0.0.1:6379> HINCRBY addresses '127.0.0.2' 1
(integer) 1
127.0.0.1:6379> HGETALL addresses
1) "127.0.0.1"
2) "2"
3) "127.0.0.2"
4) "1"
```

**2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.**

```
127.0.0.1:6379> HSET emails 'igor' 'igor_mail@example.com'
(integer) 1
127.0.0.1:6379> HSET emails 'sergey' 'sergey_mail@example.com'
(integer) 1
127.0.0.1:6379> HSET emails 'olga' 'olga_mail@example.com'
(integer) 1
127.0.0.1:6379> HGETALL emails
1) "igor"
2) "igor_mail@example.com"
3) "sergey"
4) "sergey_mail@example.com"
5) "olga"
6) "olga_mail@example.com"
```

Получение значения по ключу

```
127.0.0.1:6379> HGET emails 'igor'
"igor_mail@example.com"
```

Аналогично нужно сделать для обратного поиска, так как в `redis` нет нормализации.

```
127.0.0.1:6379> HSET users 'igor_mail@example.com' 'igor'
(integer) 1
127.0.0.1:6379> HSET users 'sergey_mail@example.com' 'sergey'
(integer) 1
127.0.0.1:6379> HSET users 'olga_mail@example.com' 'olga'
(integer) 1
127.0.0.1:6379> HGET users 'olga_mail@example.com'
"olga"
```

**3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.**

Создадим две коллекции `catalogs` и `products`. Это аналог таблицы.

```javascript
> use shop
switched to db shop
> db.createCollection('catalogs')
{ "ok" : 1 }
> db.createCollection('products')
{ "ok" : 1 }
```

Заполним коллекцию `catalogs`.

```javascript
> db.catalogs.insert({name: 'Процессоры'})
WriteResult({ "nInserted" : 1 })
> db.catalogs.insert({name: 'Материнские платы'})
WriteResult({ "nInserted" : 1 })
> db.catalogs.insert({name: 'Видеокарты'})
WriteResult({ "nInserted" : 1 })
```

Посмотрим результат.

```javascript
> db.catalogs.find()
{ "_id" : ObjectId("5ecab625717c0e295a0454bc"), "name" : "Процессоры" }
{ "_id" : ObjectId("5ecab66e717c0e295a0454bd"), "name" : "Материнские платы" }
{ "_id" : ObjectId("5ecab679717c0e295a0454be"), "name" : "Видеокарты" }
```

Используем сгенерированные `_id` для ссылки на записи в `catalogs` из коллекции `products`.

```javascript
> db.products.insert({name: 'Intel Core i3-8100', catalog_id: ObjectId('5ecab625717c0e295a0454bc'), price: 7890})
WriteResult({ "nInserted" : 1 })
> db.products.insert({name: 'AMD FX-8320E', catalog_id: ObjectId('5ecab625717c0e295a0454bc'), price: 4780})
WriteResult({ "nInserted" : 1 })
> db.products.insert({name: 'Gigabyte H310M S2H', catalog_id: ObjectId('5ecab66e717c0e295a0454bd'), price: 4780})
WriteResult({ "nInserted" : 1 })
```

В результате в коллекции `products` получим три документа cсо структурой

```javascript
{
  _id: ObjectId,
  catalog_id: ObjectId,
  name: string,
  price: number
}
```

```javascript
> db.products.find()
{ "_id" : ObjectId("5ecab71c717c0e295a0454bf"), "name" : "Intel Core i3-8100", "catalog_id" : ObjectId("5ecab625717c0e295a0454bc"), "price" : 7890 }
{ "_id" : ObjectId("5ecab741717c0e295a0454c0"), "name" : "AMD FX-8320E", "catalog_id" : ObjectId("5ecab625717c0e295a0454bc"), "price" : 4780 }
{ "_id" : ObjectId("5ecab768717c0e295a0454c1"), "name" : "Gigabyte H310M S2H", "catalog_id" : ObjectId("5ecab66e717c0e295a0454bd"), "price" : 4780 }
```
