 DROP TABLE IF EXISTS user;
 CREATE TABLE user (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя пользователя',
    birthday_at VARCHAR(255),
    created_at VARCHAR(255),
    updated_at VARCHAR(255)
 ) COMMENT = 'Пользователи';

 INSERT INTO user (name, birthday_at, created_at, updated_at) VALUES
    ('alex', '16 june 1988', '20.10.2017 8:10', '21.10.2017 8:10'),
    ('max', '17 may 1989', '22.10.2017 8:10', '23.10.2017 8:10'),
    ('kate', '18 august 1990', '24.10.2017 8:10', '25.10.2017 8:10');
