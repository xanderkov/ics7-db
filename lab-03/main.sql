-- 1. Скалярная функция

CREATE OR REPLACE FUNCTION AvgDanger() RETURNS float4 AS $$
    SELECT AVG(degree_of_danger) FROM patients;
$$ LANGUAGE SQL;

SELECT AvgDanger();

-- 2. Подставляемая табличная функция

SELECT patients.surname, doctors.surname, doctors.name
FROM patients
JOIN doctor_patient ON patients.id = doctor_patient.patient_number
    JOIN doctors ON doctors.id = doctor_patient.doctor_number
WHERE doctors.name = 'Олег'

CREATE OR REPLACE FUNCTION pd() 
    RETURNS TABLE 
            (
                psurname    text,
                dsurname        text,
                dname         text
            )
    AS $$
        SELECT patients.surname, doctors.surname, doctors.name
        FROM patients
        JOIN doctor_patient ON patients.id = doctor_patient.patient_number
            JOIN doctors ON doctors.id = doctor_patient.doctor_number
        WHERE doctors.name = 'Олег'
$$ LANGUAGE SQL;

SELECT * FROM pd();

-- 3. Многооператорная табличная функция

DROP FUNCTION pdalot();

CREATE OR REPLACE FUNCTION pdalot() 
    RETURNS TABLE 
            (
                psurname    VARCHAR(64),
                dsurname    VARCHAR(64),
                dname       VARCHAR(64),
                queu        int
            )
    AS $$
    BEGIN
        RETURN QUERY SELECT patients.surname, doctors.surname, doctors.name, 0
        FROM patients
        JOIN doctor_patient ON patients.id = doctor_patient.patient_number
            JOIN doctors ON doctors.id = doctor_patient.doctor_number
        WHERE doctors.name = 'Олег';

        RETURN QUERY SELECT patients.surname, doctors.surname, doctors.name, 1
        FROM patients
        JOIN doctor_patient ON patients.id = doctor_patient.patient_number
            JOIN doctors ON doctors.id = doctor_patient.doctor_number
        WHERE doctors.name = 'Антон';

        RETURN QUERY SELECT patients.surname, doctors.surname, doctors.name, 2
        FROM patients
        JOIN doctor_patient ON patients.id = doctor_patient.patient_number
            JOIN doctors ON doctors.id = doctor_patient.doctor_number
        WHERE doctors.name = 'Эдуард';
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM pdalot();

-- 4. Рекурсивная функция или функция с рекурсивным ОТВ

DROP FUNCTION pdrec();

CREATE OR REPLACE FUNCTION pdrec() 
    RETURNS TABLE 
            (
                id                 int,
                name                VARCHAR(64),
                degree_of_danger    int,
                room_number_next    int
            )
    AS $$
        WITH RECURSIVE most_massive_patient(id, name, degree_of_danger, room_number_next) as (
        SELECT id, name, degree_of_danger, 2
        FROM patients
        WHERE degree_of_danger = (SELECT MAX(degree_of_danger)
                        FROM patients
                        WHERE room_number = 1)
            AND room_number = 1
        UNION ALL
        SELECT p.id, p.name, p.degree_of_danger, mmp.room_number_next + 1
        FROM patients p JOIN most_massive_patient as mmp 
        ON p.room_number = mmp.room_number_next
        WHERE p.degree_of_danger = (SELECT MAX(degree_of_danger)
                            FROM patients
                            WHERE room_number = p.room_number)
        )
        SELECT * FROM most_massive_patient;
$$ LANGUAGE SQL
    RETURNS NULL ON NULL input;

SELECT * FROM pdrec();

-- 5. Хранимая цпроцедра без параметров или с параметрами

CREATE OR REPLACE PROCEDURE inspatients()
    LANGUAGE SQL
AS $$
    INSERT INTO patients (surname, name, patronymic, height, weight, 
    room_number, degree_of_danger)
    values('Ковель', 'Александр', 'Денисович', 183, 80, 69, 10);
$$;

CALL inspatients();

select surname from patients where id > 4999;

-- 6. Рекурсивная хрангимая процедура

CREATE OR REPLACE PROCEDURE RiseOfWeight(n int)
    LANGUAGE plpgsql
AS $$
    BEGIN
        IF (n < 40) THEN
            UPDATE patients
            SET weight = weight + 1 
            WHERE id = n;
            CALL RiseOfWeight(n + 1);
        END IF;
    END;
$$;

CALL RiseOfWeight(0);

select surname, weight from patients where id < 40;

-- 7. Хранимая процедура с курсором


CREATE OR REPLACE PROCEDURE weightdegree(current_degree int)
    LANGUAGE plpgsql
AS $$
    DECLARE 
        curs CURSOR FOR (SELECT *
                        FROM patients
                        WHERE degree_of_danger = current_degree);
    BEGIN
        UPDATE patients SET weight = weight - 5 WHERE current OF curs;
        CLOSE curs;
    END;
$$;

-- 8. Хранимая процедура доступа с метаданными

CREATE OR REPLACE PROCEDURE TableInfo()
    LANGUAGE plpgsql
AS $$
    BEGIN
        CREATE TABLE IF NOT EXISTS column_info AS
        SELECT * FROM information_schema.columns WHERE table_schema = 'public';
    END;
$$;

CALL TableInfo();
SELECT * FROM column_info;

-- 9. Триггер AFTER

CREATE OR REPLACE FUNCTION AlterDeletePatient()
RETURNS TRIGGER AS
$$
    BEGIN
        RAISE NOTICE 'DELETED % % % % %;', 
        old.id, old.name, old.surname, old.degree_of_danger, old.weight;

        RETURN old;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER AlterDeletePatient
    AFTER DELETE
    ON patients
EXECUTE PROCEDURE AlterDeletePatient();

DELETE FROM patients
WHERE id = 5001;

-- 10. Триггер INSTEAD OF

CREATE OR REPLACE FUNCTION UpdatePatient()
RETURNS TRIGGER AS
$$
    BEGIN
        RAISE NOTICE 'patient % % % % % %;', 
        new.name, new.patronymic, new.height, new.weight, new.room_number, new.degree_of_danger;

        INSERT INTO doctors (id, surname, name, patronymic, medical_speciality, role)
        values(DEFAULT, 'Куров', 'Андрей', 'Владимирович', 'психолог', 'лечащий врач');

        INSERT INTO patients
        VALUES (DEFAULT, new.surname, new.name, new.patronymic, new.height, new.weight, new.room_number, new.degree_of_danger);

        RETURN new;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER UpdateWithDoctor
    instead of INSERT
    ON patient_copy
    for each rowCREATE FUNCTION pymax (a integer, b integer)
RETURNS integer
AS $$
    if a > b:
        return a
    return b
$$ LANGUAGE plpython3u;

EXECUTE PROCEDURE UpdatePatient();

create view patient_copy as
select * from patients

INSERT INTO patient_copy (id, surname, name, patronymic, height, weight, 
room_number, degree_of_danger)
values(DEFAULT, 'Ковель', 'Александр', 'Денисович', 183, 80, 69, 10);

select * from patient_copy where id > 4999;
select * from doctors where id > 1999;

-- Триггер при удалении доктора
-- перебросит к доктору с наименьшим количеством пациентов

CREATE OR REPLACE FUNCTION UpdateDoctors()
RETURNS TRIGGER AS
$$
    BEGIN
        RAISE NOTICE 'doctor % % % % %;', 
        new.surname, new.name, new.patronymic
        , new.medical_speciality, new.role;
        
        DELETE FROM doctor_patient
        where doctor_number = new.id;

        DELETE FROM doctor_copy
        where id = new.id;

        UPDATE doctor_patient
        set doctor_number = (
            select min(doctor_number) as id from(
                select count(doctor_number) as number, doctor_number
                FROM doctor_patient
                GROUP BY doctor_number
                HAVING count(doctor_number) = (
                    select min(cnt) from(
                        select count(doctor_number) as cnt, doctor_number
                        from doctor_patient
                        GROUP BY doctor_number
                    ) as minfrom
                )
                ) as mf
        )
        where doctor_copy.id = new.id;

        RETURN new;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER UpdateDoctor
    instead of DELETE
    ON doctor_copy
    for each row
EXECUTE PROCEDURE UpdateDoctors();


create view doctor_copy as
select * from doctors;

DELETE from doctor_copy
where id = 1979;


select * from doctor_copy
where id > 1978;


UPDATE doctor_patient
        set doctor_number = (
            select min(doctor_number) as id from(
                select count(doctor_number) as number, doctor_number
                FROM doctor_patient
                GROUP BY doctor_number
                HAVING count(doctor_number) = (
                    select min(cnt) from(
                        select count(doctor_number) as cnt, doctor_number
                        from doctor_patient
                        GROUP BY doctor_number
                    ) as minfrom
                )
                ) as mf
        )
where doctor_patient.doctor_number = 1989;