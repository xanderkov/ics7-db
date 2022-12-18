COPY rooms(floor, number_of_beds, room_type, number_of_patients) 
FROM '/var/lib/postgresql/data/tables/room.csv'
DELIMITER ','
CSV HEADER;


COPY medicines(name, expiration_date, recipe, contraindications, side_effects) 
FROM '/var/lib/postgresql/data/tables/medicines.csv'
DELIMITER ','
CSV HEADER;

COPY mentals(name, symptoms, reasons, diagnosis, classification) 
FROM '/var/lib/postgresql/data/tables/mental.csv'
DELIMITER ','
CSV HEADER;

COPY patients(surname, name, patronymic, height, weight, room_number, degree_of_danger) 
FROM '/var/lib/postgresql/data/tables/patient.csv'
DELIMITER ','
CSV HEADER;


COPY doctors(surname, name, patronymic, medical_speciality, role) 
FROM '/var/lib/postgresql/data/tables/doctor.csv'
DELIMITER ','
CSV HEADER;

COPY doctor_patient(patient_number, doctor_number) 
FROM '/var/lib/postgresql/data/tables/doctor_patient.csv'
DELIMITER ','
CSV HEADER;

COPY medicines_patient(patient_number, medicines_number) 
FROM '/var/lib/postgresql/data/tables/medicenes_patient.csv'
DELIMITER ','
CSV HEADER;

COPY mental_patient(patient_number, mental_number) 
FROM '/var/lib/postgresql/data/tables/mental_patient.csv'
DELIMITER ','
CSV HEADER;