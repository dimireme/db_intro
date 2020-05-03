 DROP TABLE IF EXISTS catalogs;
 CREATE TABLE catalogs (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Наименование товара',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 ) COMMENT = 'Каталог ХХХ';

 INSERT INTO catalogs (name) VALUES
    ('alex_1'),
    ('jessie_2'),
    ('jasmine_3'),
    ('oudrey_4'),
    ('madison_5'),
    ('oletta_6'),
    ('nikole_7');
