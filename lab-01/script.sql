CREATE TABLE IF NOT EXISTS doctors
(
    id INT NOT NULL PRIMARY KEY,
    surname VARCHAR(64),
    name VARCHAR(64),
    patronymic VARCHAR(64),
    medical_speciality VARCHAR(20),
    role VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS medicines
(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    date VARCHAR(100),
    expiration_date VARCHAR(100),
    recipe VARCHAR(100), 
    contraindications VARCHAR(100),
    side_effects VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS mentals
(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(64),
    symptoms VARCHAR(100),
    reasons VARCHAR(100),
    diagnosis VARCHAR(100),
    classification INT CHECK (classification >= 0 AND classification <=100)
);

CREATE TABLE IF NOT EXISTS rooms
(
    number INT NOT NULL PRIMARY KEY CHECK (number >= 0 AND number <= 1500),
    floor INT CHECK (floor >= 1 AND floor <= 10),
    number_of_beds INT CHECK (number_of_beds >= 1 AND number_of_beds <= 6),
    room_type INT CHECK (room_type >= 0 AND room_type <= 10),
    number_of_patients INT CHECK (number_of_patients <= 6) 
);

CREATE TABLE IF NOT EXISTS patients
(
    id INT NOT NULL PRIMARY KEY,
    surname VARCHAR(64),
    name VARCHAR(64),
    patronymic VARCHAR(64),
    height INT CHECK (height >= 150 AND height <=200),
    weight INT CHECK (weight >= 30 AND weight <= 200),
    room_number INT CHECK (room_number >= 0 AND room_number <= 1500),
    degree_of_danger INT CHECK (degree_of_danger >= 0 AND degree_of_danger <= 10),
    FOREIGN KEY (room_number) REFERENCES rooms(number)
);



-- Проверить работу количества пациентов, от их номера палаты