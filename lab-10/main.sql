
-- Количество врачей разных специальностей
SELECT count(*), role FROM doctors GROUP BY role

-- Пациенты с депрессией
SELECT cnt FROM (
select count(*) as cnt, mentals.diagnosis
from (mentals join mental_patient on mentals.id = mental_patient.mental_number
join patients on patients.id = mental_patient.patient_number
join doctor_patient on patients.id = doctor_patient.patient_number
join doctors on doctors.id = doctor_patient.doctor_number) 
where mentals.diagnosis LIKE '%depression%'
group by mentals.diagnosis
) as c

-- Средняя опасность по больнице

SELECT avg(degree_of_danger) from patients 

-- Количество истекающих лекарств в разные даты
SELECT count(*), expiration_date FROM medicines GROUP BY expiration_date

-- Характеристика врачей
Select surname,
Case role
when 'врач' then 'Круто'
when 'ассистент' then 'Не так круто'
when 'лечащий врач' then 'Супер круто'
else 'не круто'
end as "Степень Крутости"
from doctors;