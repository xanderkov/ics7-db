--1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
--данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
--проверить все режимы конструкции FOR XML
SELECT row_to_json(c) result FROM patients c;
SELECT row_to_json(c1) result FROM doctors c1;
SELECT row_to_json(h) result FROM rooms h;
SELECT row_to_json(a) result FROM mentals a;
SELECT row_to_json(b) result FROM medicines b;

--2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
--Созданная таблица после всех манипуляций должна соответствовать таблице
--базы данных, созданной в первой лабораторной работе.

-- Копия таблицы
CREATE TABLE IF NOT EXISTS Doctors_copy(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    surname VARCHAR(64),
    name VARCHAR(64),
    patronymic VARCHAR(64),
    medical_speciality VARCHAR(20),
    role VARCHAR(20)
);

-- Копирование
-- надо через терминал (linux) сделать комнду chmod uog+w <имя файла json>
COPY
(
	SELECT row_to_json(c) RESULT FROM doctors c 
)
TO '/var/lib/postgresql/data/pgdata/json-tables/doctors.json';


-- Файл в таблицу БД
CREATE TABLE IF NOT EXISTS doctors_import(doc json);

COPY doctors_import FROM '/var/lib/postgresql/data/pgdata/json-tables/doctors.json';

SELECT * FROM doctors_import;

-- потом все в таблицу 
INSERT INTO Doctors_copy (surname, name, patronymic, medical_speciality, role)
SELECT doc->>'surname', doc->>'name', doc->>'patronymic', doc->>'medical_speciality',
	   doc->>'role' FROM doctors_import;

SELECT * FROM Doctors_copy;

--3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
--добавить атрибут с типом XML или JSON к уже существующей таблице.
--Заполнить атрибут правдоподобными данными с помощью команд INSERT
--или UPDATE.
CREATE TABLE IF NOT EXISTS doctors_json
(
	DATA json
);

INSERT INTO doctors_json
SELECT * FROM json_object('{surname, name, patronymic, medical_speciality, role}',
						  '{"Антонов", "Олег", "Эдуардович", "психолог", "лечащий врач"}');

SELECT * FROM doctors_json;

CREATE TABLE IF NOT EXISTS json_table
(
	id serial PRIMARY KEY,
	name varchar(40) NOT NULL,
	DATA json
);

insert into json_table(name, data) values 
    ('Kovel', '{"age": 20, "group": "IU7-56B"}'::json),
    ('Kovel2', '{"age": 21, "group": "IU7-57B"}'::json);

select * from json_table;

--4. Выполнить следующие действия:
--4.1. Извлечь XML/JSON фрагмент из XML/JSON документа
CREATE TABLE IF NOT EXISTS doctors_name_role
(
	name VARCHAR(64),
	role VARCHAR(20)
)

SELECT * FROM doctors_import, json_populate_record(NULL::doctors_name_role, doc);

SELECT doc->'name' name FROM doctors_import;

SELECT doc->'role' role FROM doctors_import;

--4.2. Извлечь значения конкретных узлов или атрибутов XML/JSON
--документа

SELECT data->'age' age FROM json_table;

-- !!!4.3. Выполнить проверку существования узла или атрибута
-- jsonb

CREATE OR REPLACE FUNCTION get_json_table(u_id int)
RETURNS VARCHAR AS '
    SELECT CASE
               WHEN count.cnt > 0
                   THEN ''true''
               ELSE ''false''
               END AS comment
    FROM (
             SELECT COUNT(data->''age'') cnt
             FROM json_table
         ) AS count;
' LANGUAGE sql;

SELECT * FROM json_table;

SELECT get_json_table(0);
        
DROP FUNCTION node_exists CASCADE;

CREATE OR REPLACE FUNCTION node_exists(json_check jsonb, key text)
RETURNS VARCHAR 
AS $$
BEGIN
    RETURN (json_check->key);
END;
$$ LANGUAGE PLPGSQL;

SELECT node_exists('{"name": "Kovel", "age": 20}', 'name');

--4.4. Изменить XML/JSON документ
drop table if exists json_st
CREATE TABLE json_st(doc jsonb)

insert into json_st values 
    ('{"surname": "Kovel", "info":{"age": 20, "group": "IU7-56B"}}'),
    ('{"surname": "Kovel2", "info":{"age": 21, "group": "IU7-57B"}}');

UPDATE json_st 
SET doc = doc || '{"info":{"age": 20}}'::jsonb
WHERE (doc->'info'->'age')::Int = 21;

SELECT * FROM json_st 

-- 5. Разедлить JSON документ на несколько строк по узлам
CREATE OR REPLACE PROCEDURE split_json_file()
LANGUAGE PLPGSQL
AS $$
DECLARE object_tmp TEXT;
BEGIN
    SELECT jsonb_pretty(doc)
    INTO object_tmp
    FROM json_st;
    raise notice '%', object_tmp;
END
$$;

CALL split_json_file()

-- функция которая должна вывести всех шизофренников и всех связанных врачей
CREATE TABLE IF NOT EXISTS Doctors_copy(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    surname VARCHAR(64),
    name VARCHAR(64),
    patronymic VARCHAR(64),
    medical_speciality VARCHAR(20),
    role VARCHAR(20)
);

INSERT INTO Doctors_copy (surname, name, patronymic, medical_speciality, role)
SELECT doc->>'surname', doc->>'name', doc->>'patronymic', doc->>'medical_speciality',
	   doc->>'role' FROM doctors_import;

SELECT * FROM (
select distinct mentals.diagnosis, doctors.surname, doctors.role
from (mentals join mental_patient on mentals.id = mental_patient.mental_number
join patients on patients.id = mental_patient.patient_number
join doctor_patient on patients.id = doctor_patient.patient_number
join doctors on doctors.id = doctor_patient.doctor_number) 
where mentals.diagnosis LIKE '%depression%') as c

COPY
(
    SELECT row_to_json(c) RESULT
    FROM (
    select distinct mentals.diagnosis, doctors.surname, doctors.role
    from (mentals join mental_patient on mentals.id = mental_patient.mental_number
    join patients on patients.id = mental_patient.patient_number
    join doctor_patient on patients.id = doctor_patient.patient_number
    join doctors on doctors.id = doctor_patient.doctor_number) 
    where mentals.diagnosis LIKE '%depression%') as c
)
TO '/var/lib/postgresql/data/pgdata/json-tables/shiza.json';