DROP TABLE IF EXISTS user;

CREATE TABLE user (
   id SERIAL PRIMARY KEY,
   name VARCHAR(255) COMMENT 'Имя пользователя',
   birthday_at DATE
) COMMENT = 'Пользователи';

INSERT INTO user (name, birthday_at) VALUES
   ('oletta', '1990-10-05'),
   ('jasmine', '1984-11-12'),
   ('joni', '1985-05-20'),
   ('jesse', '1988-02-14'),
   ('madison', '1998-01-12'),
   ('audrey', '2006-08-29');
