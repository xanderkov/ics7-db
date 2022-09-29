COPY rooms(number, floor, number_of_beds, room_type, number_of_patients) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/room.csv'
DELIMITER ','
CSV HEADER;


COPY medicines(id, name, expiration_date, recipe, contraindications, side_effects) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/medicines.csv'
DELIMITER ','
CSV HEADER;

COPY mentals(id, name, symptoms, reasons, diagnosis, classification) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/mental.csv'
DELIMITER ','
CSV HEADER;

COPY patients(id, surname, name, patronymic, height, weight, room_number, degree_of_danger) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/patient.csv'
DELIMITER ','
CSV HEADER;


COPY doctors(id, surname, name, patronymic, medical_speciality, role) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/doctor.csv'
DELIMITER ','
CSV HEADER;

COPY doctor_patient(patient_number, doctor_number) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/doctor_patient.csv'
DELIMITER ','
CSV HEADER;

COPY medicines_patient(patient_number, medicines_number) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/medicenes_patient.csv'
DELIMITER ','
CSV HEADER;

COPY mental_patient(patient_number, mental_number) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/mental_patient.csv'
DELIMITER ','
CSV HEADER;