select * from pg_language;
CREATE EXTENSION plpython3u;


-- 1) Определяемая пользователем скалярная функция CLR
-- имя пациента по id

CREATE or REPLACE FUNCTION get_patient_name(name_p INT)
RETURNS VARCHAR
AS $$
    res = plpy.execute(f"SELECT name FROM patients WHERE id = {name_p};")
    if res:
        return res[0]["name"]
$$ LANGUAGE plpython3u;

SELECT * FROM get_patient_name(1) as "name";

-- 2) Пользовательскую агрегатную функцию CLR.
-- Вывести количество олегов
DROP FUNCTION if exists avg_danger_n CASCADE;

CREATE or REPLACE FUNCTION avg_danger_n(a int, name_p VARCHAR)
RETURNS INT
AS $$
    n = 0
    avg = 0
    result = plpy.execute(f"select * from patients;")
    for i in result:
        if name_p == i["name"]:
            n += 1
    return n
$$ LANGUAGE plpython3u;

CREATE AGGREGATE patient_in_hospital_n(VARCHAR)
(
    sfunc = avg_danger_n,
    stype = int
);

SELECT patient_in_hospital_n('Олег') FROM patients

-- 3) Опредляемая пользователем табличная функция CLR
-- Вывести врачей
CREATE or REPLACE FUNCTION get_doctors(role VARCHAR)
RETURNS TABLE
(
    id int,
    name VARCHAR,
    surname VARCHAR
)
AS $$
    sq = plpy.execute("SELECT id, name, surname, role from doctors")
    
    need_role = None
    for elem in sq:
        if elem["role"] == role:
            need_role = elem["role"]
    res = []
    for elem in sq:
        if elem["role"] == need_role:
            res.append(elem)
    return res
$$ LANGUAGE plpython3u;
SELECT id, name, surname, role from doctors

SELECT * FROM get_doctors('лечащий врач');

-- 4) Хранимая процедура CLR
-- Обновить Олегов

CREATE or REPLACE PROCEDURE print_fl(height_p INT)
AS $$
    sql_q = plpy.prepare(f"UPDATE patients \
set height = $1 \
where name LIKE 'Олег';", ["INT"])
    plpy.execute(sql_q, [height_p])
$$ LANGUAGE plpython3u;

CALL add_to_table(169);

select * from patients where name = 'Олег';

-- 5) Триггер CLR

CREATE OR REPLACE FUNCTION on_delete_tr()
RETURNS TRIGGER
AS $$
    del_id = TD["old"]["id"]
    run = plpy.execute(f"\
    update patients set name = 'trigger' \
    where patients.id = {del_id}")
    return TD["new"]
$$ LANGUAGE plpython3u;

DROP TRIGGER trigger_delete ON patients;

create view patients_copy as
select * from patients;

CREATE TRIGGER trigger_delete
INSTEAD OF DELETE on patients_copy
FOR each row
EXECUTE PRocedure on_delete_tr();

DELETE FROM patients_copy
WHERE id = 5035;

SELECT * from patients_copy where id > 4998;

INSERT INTO patients (surname, name, patronymic, height, weight, 
room_number, degree_of_danger)
values('Ковель', 'Александр', 'Денисович', 183, 80, 69, 10);

-- 6) Определяемый пользователем тип данных CLR
CREATE TYPE most_danger as
(
    room_number INT,
    degree_of_danger INT
);

CREATE OR REPLACE FUNCTION get_most_danger(room_n INT)
RETURNS most_danger
AS
$$
    plan = plpy.prepare("\
    SELECT room_number, degree_of_danger \
    FROM patients \
    WHERE room_number = $1;", ["integer"])

    sq = plpy.execute(plan, [room_n])

    if (sq.nrows()):
        return (sq[0]["room_number"], sq[0]["degree_of_danger"])
$$ LANGUAGE plpython3u;

SELECT * FROM get_most_danger('69');

-- функцию по преобазования доктора в больного 

CREATE OR REPLACE PROCEDURE insert_doctor(id INT)
AS $$
    sql_q = plpy.prepare(f"INSERT INTO patients (surname, name, patronymic) \
    select surname, name, patronymic \
    from doctors \
    where id = $1", ["INT"])

    plpy.execute(sql_q, [id])

    sql_q = plpy.prepare(f"DELETE from doctor_patient \
    where doctor_number = $1", ["INT"])

    plpy.execute(sql_q, [id])

    sql_q = plpy.prepare(f"DELETE from doctors \
    where id = $1", ["INT"])

    plpy.execute(sql_q, [id])
$$ LANGUAGE plpython3u;

CALL insert_doctor(1998);
SELECT * from doctors where id = 1998;
SELECT * from patients where id > 4999;