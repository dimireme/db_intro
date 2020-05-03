DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
    id SERIAL PRIMARY KEY,
    value INT NOT NULL DEFAULT 0 COMMENT 'Доступное количество'
) COMMENT 'Складские запасы';

INSERT INTO storehouses_products (value) VALUES
    (0),
    (2500),
    (0),
    (30),
    (500),
    (1);
