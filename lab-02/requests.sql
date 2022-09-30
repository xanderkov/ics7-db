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
-- 11
