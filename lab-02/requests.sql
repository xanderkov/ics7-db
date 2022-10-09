select * from rooms 
where number > 1488;

-- 2 - 
select * from medicines
where id BETWEEN 1488 and 1500;
-- 3 -- Если в диагнозе присутсвуют depression
select distinct diagnosis
from mentals
where diagnosis LIKE '%depression%';
-- 4 - Пациенты которые живут в комнатах с 1488 по 1490
select distinct name
from patients
where room_number IN (
select distinct number
from rooms
where number 
BETWEEN 1488 and 1490);
-- 5 - Где существуют пациенты, которые живут в комнатах > 1488 и тип комнаты = 9
select name,surname from patients
where EXISTS (
select number, room_type
from rooms
where room_type = 9 
and number > 1488 
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
ON patients.room_number = rooms.number and rooms.floor = 6 and rooms.room_type > 7
doctors.id = patients.id; 
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