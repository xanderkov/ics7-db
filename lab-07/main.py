import sqlalchemy
from sqlalchemy import create_engine, select, insert, update, delete, func
from sqlalchemy.orm import Session, sessionmaker, class_mapper

from json import dumps, load

from models import Patients, Doctors, Rooms, Medicines, Mentals, DoctorPatient, PatientMental, MedicinePatient


# LINQ to Object
# 1. Вывести список всех пациентов
def get_name_patients(session):
    data = session.query(Patients).all()
    for row in data:
        print(row.name)


# 2. Вывести всех пациентов у которых опасность совпадает с типом комнаты
def get_patients_danger(session):
    data = session.query(Patients).join(Patients.room_number_rel).where(
        Patients.degree_of_danger == Rooms.room_type).order_by(Patients.id).all()
    for row in data:
        print((row.id, row.name, row.surname, int(row.degree_of_danger), int(row.room_number)))


# 3. Вывести средную опасность пациентов
def get_avg_patients(session):
    data = session.query(func.avg(Patients.degree_of_danger).label("avg"))
    for row in data:
        print(row.avg)


# 4. Вывести количество пациентов в палатах
def get_count_patients(session):
    data = session.query(
        Rooms.number,
        func.count(Patients.name).label("count_patients")
    ).join(Rooms).group_by(Rooms.number).all()
    for row in data:
        print((row.count_patients, row.number))


# 5. Вывести пациента и докторов, которые лечат этого пациента
def get_patients_and_doctors(session):
    data = session.query(
        Patients.name,
        Doctors.name,
    ).filter(
        Patients.id == DoctorPatient.patient_number,
    ).filter(
        Doctors.id == DoctorPatient.doctor_number,
    )
    for row in data:
        print(row)


# LINQ to JSON
# 1. Запись в Json

def serialize_all(model):

    columns = [c.key for c in class_mapper(model.__class__).columns]
    return dict((c, getattr(model, c)) for c in columns)


def patients_to_json(session):
    serialized_labels = [
        serialize_all(label)
        for label in session.query(Patients).order_by(Patients.id).all()
    ]

    for dt in serialized_labels:
        dt["name"] = str(dt["name"])
        dt["surname"] = str(dt["surname"])
        dt["patronymic"] = str(dt["patronymic"])

    with open('patients.json', 'w') as f:
        f.write(dumps(serialized_labels, indent=4))


def read_json():
    with open('patients.json') as f:
        patient = load(f)

    for p in patient:
        print(p)

    # LINQ to SQL


# 1. Однотабличный запрос на выборку. (Вывести фио пациента)
def select_name_patients(session):
    res = session.execute(
        select(Patients.name, Patients.surname, Patients.patronymic)
    )

    for g in res:
        print(g)


# 2. Многотабличный запрос на выборку. (Вывести фио пациентов и докторов)

def select_patinets_and_doctors(session):
    res = session.execute("""
        SELECT p.name, p.surname, p.patronymic, d.name, d.surname, d.patronymic
        FROM patients p
        JOIN doctor_patient dp ON p.id = dp.patient_number
        JOIN doctors d ON d.id = dp.doctor_number
    """)
    for pl in res:
        print(pl)


# 3. Добавление данных в таблицу  insert into doctors
def insert_into_doctors(session):
    try:
        name = input("Имя доктора: ")
        surname = input("Фамилия доктора: ")

        session.execute(
            insert(Doctors).values(
                name=name,
                surname=surname,
            )
        )
        session.commit()
        print("Данные успешно добавлены!")
    except:
        print("error input data")
        return


# Обновление данных update doctors
def select_doctors_all(session):
    data = session.query(Doctors).order_by(Doctors.id).all()
    for d in data:
        print(d.name, d.surname, d.medical_speciality)


# Обновление данных update tp.games
def update_doctors(session):
    name = input("Имя доктора: ")
    surname = input("Фамилия доктора: ")
    spec = input("Новая специальность доктора: ")

    exists = session.query(
        session.query(Doctors).where(Doctors.name == name and Doctors.surname == surname).exists()
    ).scalar()

    if not exists:
        print("Такого врача нет!")
        return

    session.execute(
        update(Doctors).where(Doctors.name == name and Doctors.surname == surname).values(medical_speciality=spec)
    )
    session.commit()
    print("Данные успешно измененны!")


# Удаление данных delete tp.games
def delete_doctors(session):
    name = input("Имя доктора: ")
    surname = input("Фамилия доктора: ")

    exists = session.query(
        session.query(Doctors).where(Doctors.name == name and Doctors.surname == surname).exists()
    ).scalar()

    if not exists:
        print("Такого врача нет!")
        return

    session.execute(
        delete(Doctors).where(Doctors.name == name and Doctors.surname == surname)
    )
    session.commit()
    print("Данные успешно удалены!")


# 4. Вызов функци
def call_func(session):
    data = session.execute(f"SELECT current_timestamp").all()
    for row in data:
        print(row)


MSG = "Меню\n\n" \
      "--------- LINQ_to_Object -------------- \n" \
      "5 запросов созданные для проверки LINQ\n" \
      "1. Вывести список всех пациентов\n" \
      "2. Вывести всех пациентов у которых опасность совпадает с типом комнаты \n" \
      "3. Вывести средную опасность пациентов \n" \
      "4. Вывести количество пациентов в палатах \n" \
      "5. Вывести пациента и доктора \n" \
      "\n--------- LINQ_to_JSON -------------- \n" \
      "6. Запись в JSON документ. \n" \
      "7. Чтение из JSON документа. \n" \
      "8. Обновление JSON документа. \n" \
      "--------- LINQ_to_SQL -------------- \n" \
      "\nСоздать классы сущностей, которые моделируют таблицы Вашей базы данных\n" \
      "9. Однотабличный запрос на выборку. (Вывести фио пациента)\n" \
      "10. Многотабличный запрос на выборку. (Вывести фио пациентов и докторов)\n" \
      "Три запроса на добавление, изменение и удаление данных в базе данных\n" \
      "11. Добавление данных в таблицу  insert into doctors\n" \
      "12. Обновление данных update doctors\n" \
      "13. Удаление данных delete doctors\n" \
      "14. Select * from doctors\n" \
      "\nПолучение доступа к данным, выполняя только хранимую процедуру\n" \
      "15. Вызов функции\n" \
      "\n0. Выход \n\n" \
      "Выбор: "


def input_command():
    try:
        command = int(input(MSG))
        print()
    except:
        command = -1

    if command < 0 or command > 15:
        print("\nОжидался ввод целого числа от 0 до 15")

    return command


def main():
    print("Версия SQL Alchemy:", sqlalchemy.__version__)

    engine = create_engine(
        f'postgresql://postgres:postgres@localhost:5432/mental_hospital',
        pool_pre_ping=True)
    try:
        engine.connect()
        print("БД под именнем  tp успешно подключена!")
    except:
        print("Ошибка соединения к БД!")
        return

    Session = sessionmaker(bind=engine)
    session = Session()
    command = -1

    while command != 0:
        command = input_command()

        if command == 1:
            get_name_patients(session)
        elif command == 2:
            get_patients_danger(session)
        elif command == 3:
            get_avg_patients(session)
        elif command == 4:
            get_count_patients(session)
        elif command == 5:
            get_patients_and_doctors(session)
        elif command == 6:
            patients_to_json(session)
        elif command == 7:
            read_json()
        elif command == 8:
            print()
        elif command == 9:
            select_name_patients(session)
        elif command == 10:
            select_patinets_and_doctors(session)
        elif command == 11:
            insert_into_doctors(session)
        elif command == 12:
            update_doctors(session)
        elif command == 13:
            delete_doctors(session)
        elif command == 14:
            select_doctors_all(session)
        elif command == 15:
            call_func(session)
        else:
            continue


if __name__ == "__main__":
    main()