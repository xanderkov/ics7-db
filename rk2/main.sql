CREATE database rk2;

-- create table of product with date time of term


DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE IF NOT EXISTS products
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    production_date date NOT NULL,
    term date NOT NULL,
    name_of_reciver VARCHAR(100)
);

DROP TABLE IF EXISTS dishes CASCADE;
CREATE TABLE IF NOT EXISTS dishes
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    what_is VARCHAR(256),
    rate INT NOT NULL
);

DROP TABLE IF EXISTS menu CASCADE;
CREATE TABLE IF NOT EXISTS menu
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    reception VARCHAR(100),
    what_is VARCHAR(100)
);

DROP TABLE IF EXISTS dishes_menu CASCADE;
CREATE TABLE IF NOT EXISTS dishes_menu
(
    menu_number INT NOT NULL,
    FOREIGN KEY (menu_number) REFERENCES menu(id),
    dishes_number INT NOT NULL,
    FOREIGN KEY (dishes_number) REFERENCES dishes(id)
);

DROP TABLE IF EXISTS products_dishes CASCADE;
CREATE TABLE IF NOT EXISTS products_dishes
(
    dishes_number INT NOT NULL,
    FOREIGN KEY (dishes_number) REFERENCES dishes(id),
    products_number INT NOT NULL,
    FOREIGN KEY (products_number) REFERENCES products(id)
);

-- Добавить от десяти продуктов в таблицу products
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('milk', '2020-01-01', '2022-01-10', 'milk_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('bread', '2020-01-01', '2022-01-10', 'bread_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('meat', '2020-01-01', '2021-01-10', 'meat_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('fish', '2020-01-01', '2021-10-10', 'fish_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('potato', '2020-01-01', '2022-03-10', 'potato_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('tomato', '2020-01-01', '2022-04-10', 'tomato_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('cucumber', '2020-01-01', '2021-05-10', 'cucumber_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('onion', '2020-01-01', '2022-06-10', 'onion_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('carrot', '2020-01-01', '2021-07-10', 'carrot_reciver');
INSERT INTO products (name, production_date, term, name_of_reciver) VALUES ('apple', '2020-01-01', '2022-05-10', 'apple_reciver');

SELECT * FROM products;

-- Добавить блюда
INSERT INTO dishes (name, what_is, rate) VALUES ('soup', 'soup is soup', 5);
INSERT INTO dishes (name, what_is, rate) VALUES ('salad', 'salad is salad', 4);
INSERT INTO dishes (name, what_is, rate) VALUES ('cake', 'cake is cake', 3);
INSERT INTO dishes (name, what_is, rate) VALUES ('pizza', 'pizza is pizza', 2);
INSERT INTO dishes (name, what_is, rate) VALUES ('pasta', 'pasta', 1);
INSERT INTO dishes (name, what_is, rate) VALUES ('borsch', 'borsch', 5);
INSERT INTO dishes (name, what_is, rate) VALUES ('sushi', 'sushi', 4);
INSERT INTO dishes (name, what_is, rate) VALUES ('sandwich', 'sandwich', 3);
INSERT INTO dishes (name, what_is, rate) VALUES ('pancake', 'pancake', 2);
INSERT INTO dishes (name, what_is, rate) VALUES ('omelet', 'omelet', 1);

SELECT * from dishes;

-- Добавить меню от 10
INSERT INTO menu (name, reception, what_is) VALUES ('breakfast', 'morning', 'breakfast');
INSERT INTO menu (name, reception, what_is) VALUES ('lunch', 'day', 'lunch');
INSERT INTO menu (name, reception, what_is) VALUES ('dinner', 'evening', 'dinner');
INSERT INTO menu (name, reception, what_is) VALUES ('supper', 'night', 'supper');
INSERT INTO menu (name, reception, what_is) VALUES ('breakfast', 'morning', 'breakfast');
INSERT INTO menu (name, reception, what_is) VALUES ('lunch', 'day', 'lunch');
INSERT INTO menu (name, reception, what_is) VALUES ('dinner', 'evening', 'dinner');
INSERT INTO menu (name, reception, what_is) VALUES ('supper', 'night', 'supper');
INSERT INTO menu (name, reception, what_is) VALUES ('breakfast', 'morning', 'breakfast');
INSERT INTO menu (name, reception, what_is) VALUES ('lunch', 'day', 'lunch');

SELECT * from menu;

-- Добавить связь между блюдами и меню
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (1, 1);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (1, 2);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (1, 3);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (1, 4);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (1, 5);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (2, 6);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (2, 7);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (2, 8);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (2, 9);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (2, 10);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (3, 1);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (3, 2);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (3, 3);
INSERT INTO dishes_menu (menu_number, dishes_number) VALUES (3, 4);

SELECT * from dishes_menu;

-- Добавить связь между продуктами и блюдами
INSERT INTO products_dishes (dishes_number, products_number) VALUES (1, 1);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (1, 2);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (1, 3);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (1, 4);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (1, 5);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (2, 6);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (2, 7);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (2, 8);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (2, 9);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (2, 10);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (3, 1);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (3, 2);
INSERT INTO products_dishes (dishes_number, products_number) VALUES (3, 3);

SELECT * from products_dishes;

-- Найти блюда у которых истекает срок годности в 2022

SELECT dishes.name FROM dishes
JOIN products_dishes ON dishes.id = products_dishes.dishes_number
JOIN products ON products_dishes.products_number = products.id
WHERE products.term > ALL( select term from products where term < '2022-01-01');

-- Найти количество блюд для завтраков
SELECT dishes.name, COUNT(menu.name) FROM dishes
JOIN dishes_menu ON dishes.id = dishes_menu.dishes_number
JOIN menu ON dishes_menu.menu_number = menu.id
GROUP BY dishes.name, menu.name
HAVING menu.name = 'breakfast';

-- Найти блюда которые есть на завтрак и добавить их в новую временную таблицу
DROP TABLE IF EXISTS new_table;
CREATE TEMP TABLE new_table AS
SELECT dishes.name, COUNT(menu.name) FROM dishes
JOIN dishes_menu ON dishes.id = dishes_menu.dishes_number
JOIN menu ON dishes_menu.menu_number = menu.id
GROUP BY dishes.name, menu.name
HAVING menu.name = 'breakfast';

Select * from new_table;


-- Создать схему doo
CREATE SCHEMA dbo;

-- Создать процедуру которая будет удалять все таблицы из схемы dbo которые начинаются на TableName
CREATE OR REPLACE PROCEDURE drop_tables()
LANGUAGE plpgsql
AS $$
    DECLARE
        table_name_i text;
    BEGIN
        FOR table_name_i IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'dbo' and table_name like 'tablename%'
        LOOP
            EXECUTE 'DROP TABLE IF EXISTS dbo.' || table_name_i || ' CASCADE';
        END LOOP;
    END;
$$;
CALL drop_tables();

-- СОздать таблицы, которые начинаются на TableName
CREATE TABLE IF NOT EXISTS dbo.TableName1 (id INT);
CREATE TABLE IF NOT EXISTS dbo.TableName2 (id INT);
CREATE TABLE IF NOT EXISTS dbo.TableName3 (id INT);

-- Проверка, что таблицы исчезли
SELECT * from information_schema.tables where table_schema = 'dbo' and table_name like 'tablename%';

