DROP TABLE IF EXISTS doctors CASCADE;
CREATE TABLE IF NOT EXISTS doctors
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    surname VARCHAR(64),
    name VARCHAR(64),
    patronymic VARCHAR(64),
    medical_speciality VARCHAR(20),
    role VARCHAR(20)
);

DROP TABLE IF EXISTS medicines CASCADE;
CREATE TABLE IF NOT EXISTS medicines
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    date VARCHAR(100),
    expiration_date DATE NOT NULL,
    recipe VARCHAR(100), 
    contraindications VARCHAR(100),
    side_effects VARCHAR(100)
);

DROP TABLE IF EXISTS mentals CASCADE;
CREATE TABLE IF NOT EXISTS mentals
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(64),
    symptoms VARCHAR(100),
    reasons VARCHAR(100),
    diagnosis VARCHAR(100),
    classification INT CHECK (classification >= 0 AND classification <=100)
);

DROP TABLE IF EXISTS rooms CASCADE;
CREATE TABLE IF NOT EXISTS rooms
(
    number INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY CHECK (number >= 0 AND number <= 1500),
    floor INT CHECK (floor >= 1 AND floor <= 10),
    number_of_beds INT CHECK (number_of_beds >= 1 AND number_of_beds <= 6),
    room_type INT CHECK (room_type >= 0 AND room_type <= 10),
    number_of_patients INT CHECK (number_of_patients <= 6) 
);

DROP TABLE IF EXISTS patients CASCADE;
CREATE TABLE IF NOT EXISTS patients
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    surname VARCHAR(64),
    name VARCHAR(64),
    patronymic VARCHAR(64),
    height INT CHECK (height >= 150 AND height <=200),
    weight INT CHECK (weight >= 30 AND weight <= 200),
    room_number INT CHECK (room_number >= 0 AND room_number <= 1500),
    degree_of_danger INT CHECK (degree_of_danger >= 0 AND degree_of_danger <= 10),
    FOREIGN KEY (room_number) REFERENCES rooms(number)
);

DROP TABLE IF EXISTS doctor_patient CASCADE;
CREATE TABLE IF NOT EXISTS doctor_patient
(
    patient_number INT NOT NULL,
    FOREIGN KEY (patient_number) REFERENCES patients(id),
    doctor_number INT NOT NULL,
    FOREIGN KEY (doctor_number) REFERENCES doctors(id)
);

DROP TABLE IF EXISTS medicines_patient CASCADE;
CREATE TABLE IF NOT EXISTS medicines_patient
(
    patient_number INT NOT NULL,
    FOREIGN KEY (patient_number) REFERENCES patients(id),
    medicines_number INT NOT NULL,
    FOREIGN KEY (medicines_number) REFERENCES medicines(id)
);

DROP TABLE IF EXISTS mental_patient CASCADE;
CREATE TABLE IF NOT EXISTS mental_patient
(
    patient_number INT NOT NULL,
    FOREIGN KEY (patient_number) REFERENCES patients(id),
    mental_number INT NOT NULL,
    FOREIGN KEY (mental_number) REFERENCES medicines(id)
);
