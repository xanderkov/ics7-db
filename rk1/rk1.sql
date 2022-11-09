-- 1.1
select floor, count(*) as total
from rooms
group by floor
HAVING floor = 6

-- 1.2
select doctors.name, count(doctor_patient.doctor_number) as cnt, degree_of_danger
from (doctors JOIN doctor_patient 
    on doctors.id = doctor_patient.doctor_number)
    join patients on patients.id = doctor_patient.patient_number
GROUP BY doctor_patient.doctor_number, doctors.name, patients.degree_of_danger
HAVING patients.degree_of_danger = 10

-- 
((SUMMRIZE (D where D[FIO] = ':jgf') join F) per F{Did})