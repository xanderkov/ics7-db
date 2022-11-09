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
    old_id = TD["old"]
    run = plpy.execute(f"RAISE NOTICE 'DELETED % % % % %;', \
        old.id, old.name, old.surname, old.degree_of_danger, old.weight;")
    return TD["new"]
$$ LANGUAGE plpython3u;

DROP TRIGGER trigger_delete ON patients;

CREATE TRIGGER trigger_delete
AFTER DELETE on patients
EXECUTE PRocedure on_delete_tr();

DELETE FROM patients
WHERE id = 5034;

SELECT * from patients where id > 4998;

INSERT INTO patients (surname, name, patronymic, height, weight, 
room_number, degree_of_danger)
values('Ковель', 'Александр', 'Денисович', 183, 80, 69, 10);