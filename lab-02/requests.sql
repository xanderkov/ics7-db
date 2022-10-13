-- 1
select * from rooms 
where number < 13;
-- 2 - 
select * from( 
select * from mentals
where id BETWEEN 13 and 69) as od
where id = 13 or id = 69
;
-- 3 -- Если в диагнозе присутсвуют depression
select distinct diagnosis
from mentals
where diagnosis LIKE '%depression%';
-- 4 - Пациенты которые живут в комнатах с 1488 по 1490
select name, surname, patronymic
from patients
where room_number IN (
select number
from rooms
where number 
BETWEEN 1488 and 1490);
-- 5 - Где существуют пациенты, которые живут в комнатах < 13 и тип комнаты = 9
select name,surname from patients
where EXISTS (
select distinct 1
from rooms
where room_type = 9 
and number < 13 
and patients.id = number);
-- 6 - Вывести всех пациентов, у которых степень опасности = 9
select name, surname, degree_of_danger
from patients
where degree_of_danger > ALL ( select degree_of_danger 
from patients
where degree_of_danger = 9);
-- 7  -- Вывести среднюю опасность по больнице
SELECT AVG(degree_of_danger) From patients;
-- 8 -- Имя, фамилия, средняя опасность пациентов на шестом этаже, у которых вес между 190 и 200 и номер от 13 69
select name, surname, 
(select AVG(degree_of_danger) 
from patients, rooms 
where rooms.floor = 6 
and rooms.number = patients.room_number) 
from patients 
where weight BETWEEN 190 and 200 
and id BETWEEN 13 and 69;
-- 9 -- Степень крутости специальности врача
Select surname,
Case role
when 'врач' then 'Круто'
when 'ассистент' then 'Не так круто'
when 'лечащий врач' then 'Супер круто'
else 'не круто'
end as "Степень Крутости"
from doctors;
-- 10 - Дать пацентом храктеристику для врачей
 select surname,
Case
when degree_of_danger < 3 then 'Не интересный'
when degree_of_danger < 6 then 'Можно исследовать'
when degree_of_danger < 10 then 'Стоит провести эксперемент'
else 'ВРоде таких нет'
end as "Степень интересности"
from patients;
-- 11 -- Получить временную таблицу с средним весом и опасности, от палаты 6 до 13
SELECT name, surname, AVG(degree_of_danger) AS avgdg, AVG(weight)
INTO TEMP Avg_Temp_In_Hospital
FROM patients
where room_number BETWEEN 6 and 13
GROUP BY id;
-- 12 -- Вывести таблицу пациентов и комнат, где номер пациента совпадает с номером комнаты и...
SELECT patients.name, patients.surname, rooms.number, rooms.floor, rooms.room_type
from patients 
JOIN
rooms
ON patients.room_number = rooms.number and rooms.floor = 6 and rooms.room_type > 7;
-- 13 Найти пациентов у котрых степень опасность равна степени опапсности палаты, где максимальное пациентво
select name, surname
from patients
where degree_of_danger =
    (select room_type
     from rooms
     GROUP BY room_type
     HAVING sum(number_of_patients) = 
     (
        select max(nop)
        from (select sum(number_of_patients) as nop
               from rooms
               GROUP BY room_type
             ) as od
     )
    );
-- 14 Вывести пациентов у которых степень опасности = 10 и вес больше 180
select degree_of_danger, weight, name
from patients
where degree_of_danger = 10 and weight > 180
GROUP BY degree_of_danger, weight, name;
-- 15 Вывести пацентов средний вес которых больше максимальной степени опасности болезний
select id, name, avg(weight)
from patients
GROUP BY id
HAVING avg(weight) > (select max(classification)
from mentals
);
-- 16 Вставить пациента в таблицу
INSERT INTO patients (surname, name, patronymic, height, weight, 
room_number, degree_of_danger)
values('Ковель', 'Александр', 'Денисович', 183, 80, 69, 10);
-- 17 Вставить врачей в пациентов, имя которых является ОЛЕГ
INSERT INTO patients (surname, name, patronymic)
select surname, name, patronymic
from doctors
where name = 'Олег';
-- 18 задать олегом рост 169
UPDATE patients
set height = 169
where name LIKE 'Олег';
-- 19 Задать Олегам средний вес Антонов
explain
UPDATE patients
set weight = (select avg(weight)
               from patients
               where name = 'Антон')
where name LIKE 'Олег';
explain
select * from patients
where name like 'Олег%';
-- 20 удалить пациентов у которых id null
DELETE from patients
where id is NULL;
-- 21 удалить пациентов врача Олега, который яыляется лечащий врач и терапевт
DELETE from patients
where surname = (
   select surname
   from doctors
   where doctors.name like 'Олег' 
   and role 
   like 'лечащий врач'count
   and medical_speciality
   like 'терапевт'
);
-- 22 вывести количество палат каждого типа
with type_of_rooms (degree_of_danger, count) as (
   select room_type, count(*) as total
   from rooms
   GROUP by room_type
)
select * from type_of_rooms;
-- 23 вывести самых опасных пациентов в палате, если они находятся в каждой палате
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
-- 24 вывести самых опасных пациентво и тех кто лежит с ними в палате, показав максимальных уровень опасности
SELECT *, 
        MAX(degree_of_danger) OVER (ORDER BY room_number)
FROM patients;
-- 25 Выделение дубликатов в таблице пациентов
WITH DuplicatesForDelete(Row) AS (
	SELECT ROW_NUMBER() OVER(PARTITION BY p.name, p.surname, p.patronymic, p.weight, p.height 
    ORDER BY Name, surname, patronymic, weight, height) AS Row 
	FROM patients p
)
Select * FROM DuplicatesForDelete WHERE Row > 1;

--  Найти таблицы в котором больше трех атрибутов

WITH Three(Row, name) AS (
    SELECT ROW_NUMBER() OVER(PARTITION BY table_name) as row, table_name as name
    from information_schema.columns
    where table_catalog = 'mental_hospital' 
and table_schema = 'public'

) select distinct name, row from three where row > 2
GROUP BY name;

-- Подзапрос, чтобы всё это безобразие найти
select "column_name", table_name from information_schema.columns
where table_catalog = 'mental_hospital' 
and table_schema = 'public'
-- ЭТо мой запрос для умных
explain
WITH Three(Row, name) AS (
    SELECT ROW_NUMBER() OVER(PARTITION BY table_name) as row, 
    table_name as name
    from information_schema.columns
    where table_catalog = 'mental_hospital' 
and table_schema = 'public'

) select name from three where row > 2
GROUP BY three.name
HAVING MAX(three.row) > 2;
-- Гаврилова умнее меня это ее запрос
explain
SELECT table_name
 FROM information_schema.columns
    where table_catalog = 'mental_hospital' 
and table_schema = 'public'
group by table_name
having count(*) > 2

