DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (
	value INT COMMENT 'Значение'
) COMMENT = 'Числа для перемножения';

INSERT INTO numbers (value) VALUES (1), (2), (3), (4), (5);
