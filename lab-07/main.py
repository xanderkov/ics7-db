import sqlalchemy
from sqlalchemy import create_engine, select, insert, update, delete, func
from sqlalchemy.orm import Session, sessionmaker, class_mapper

from json import dumps, load

from models import *


# LINQ to Object
# 1. Вывести список всех пациентов
def get_name_patients(session):
    data = session.query(Companies).join(Companies.typiescompany).all()
    for row in data:
        print((row.name, row.typiescompany.name))


# 2. Вывести всех пациентов у которых опасность совпадает с типом комнаты
def get_patients_danger(session):
    data = session.query(Games).where(Games.developer == Games.publisher).order_by(Games.id).all()
    for row in data:
        print((row.id, row.name, row.type, float(row.price), str(row.date_publish)))


# 3. Вывести средную опасность пациентов
def get_avg_patients(session):
    data = session.query(func.avg(Games.price).label("avg_price"))
    for row in data:
        print(row.avg_price)


# 4. Вывести количество пациентов на 6 этаже
def get_count_patients(session):
    games_support = session.query(
        (Games.name).label("game"),
        func.count(Games.name).label('count_platfroms'),
    ).join(Supports).join(Platforms).group_by(Games.name).all()
    for row in games_support:
        print((row.game, row.count_platfroms))


# 5. Вывести пациента и доктора
def get_patients_and_doctors(session):
    data = session.query(Games.name, Games.price, (Games.price * Games.number_copies).label("actives")).all()
    for row in data:
        print((row.name, float(row.price), float(row.actives)))


# LINQ to JSON
# 1. Запись в Json

def serialize_all(model):

    columns = [c.key for c in class_mapper(model.__class__).columns]
    return dict((c, getattr(model, c)) for c in columns)


def patients_to_json(session):
    serialized_labels = [
        serialize_all(label)
        for label in session.query(Games).order_by(Games.id).all()
    ]

    for dt in serialized_labels:
        dt["date_publish"] = str(dt["date_publish"])
        dt["price"] = float(dt["price"])

    with open('lab_07/patients.json', 'w') as f:
        f.write(dumps(serialized_labels, indent=4))


def read_json():
    with open('lab_07/patients.json') as f:
        games = load(f)

    for g in games:
        print(g)

    # LINQ to SQL


# 1. Однотабличный запрос на выборку. (Вывести название пациента)
def select_name_patients(session):
    res = session.execute(
        select(Games.name, Games.price)
    )

    for g in res:
        print((g.name, float(g.price)))


# 2. Многотабличный запрос на выборку. (Вывести название пациентов и докторов)

def select_patinets_and_doctors(session):
    res = session.execute("""
        Select * from (Select p.name as platform, count(*) as count_games from tp.platforms as p
        join tp.supports as s on s.platformid = p.id
        group by p.id) as dp 
        where dp.count_games > 500   
        """)
    for pl in res:
        print(pl)


# 3. Добавление данных в таблицу  insert into doctors
def insert_into_doctors(session):
    try:
        name = input("Название игры: ")
        type = input("Тип: ")
        developer = input("Разработчик: ")
        publisher = input("Издатель: ")
        req_age = int(input("Огр. возраст: "))
        date_pubish = input("Дата выпуска: ")
        price = float(input("Цена: "))
        num_copies = int(input("Кол-во копий: "))

        count_games = session.query(func.count(Games.name)).all()
        id = count_games[0][0] + 1

        find_dev = session.query(Companies.id).join(Games, Companies.id == Games.developerID). \
            where(Companies.name.like('Valve%')).group_by(Companies.id).all()
        if find_dev:
            developer = find_dev[0][0]
        else:
            print("не существует!")
            return

        find_pub = session.query(Companies.id).join(Games, Companies.id == Games.developerID). \
            where(Companies.name.like('Valve%')).group_by(Companies.id).all()
        if find_pub:
            publisher = find_pub[0][0]
        else:
            print("не существует!")
            return

        session.execute(
            insert(Games).values(
                id=id,
                name=name,
                type=type,
                developer=developer,
                publisher=publisher,
                req_age=req_age,
                date_publish=date_pubish,
                number_copies=num_copies,
                price=price
            )
        )
        session.commit()
        print("Данные успешно добавлены!")
    except:
        print("error input data")
        return


# Обновление данных update doctors
def select_doctors_all(session):
    games = session.query(Games).order_by(Games.id).all()
    for g in games:
        print((g.id, g.name, g.type, g.developer, g.publisher, g.req_age, str(g.date_publish), float(g.price),
               g.number_copies))


# Обновление данных update tp.games
def update_doctors(session):
    name = input("Название игры: ")
    price = float(input("Новая цена для игры: "))

    exists = session.query(
        session.query(Games).where(Games.name == name).exists()
    ).scalar()

    if not exists:
        print("Такой игры нет!")
        return

    session.execute(
        update(Games).where(Games.name == name).values(price=price)
    )
    session.commit()
    print("Данные успешно измененны!")


# Удаление данных delete tp.games
def delete_doctors(session):
    name = input("Название игры для удаления: ")

    exists = session.query(
        session.query(Games).where(Games.name == name).exists()
    ).scalar()

    if not exists:
        print("Такой игры нет!")
        return

    session.execute(
        delete(Games).where(Games.name == name)
    )
    session.commit()
    print("Данные успешно удалены!")


# 4. Вызов функци
def call_func(session):
    numbers = int(input("Введите кол-во игр у игроков: "))
    data = session.execute(f"Select * from tp.get_clients(%d);" % (numbers)).all()
    for row in data:
        print(row)


MSG = "Меню\n\n" \
      "--------- LINQ_to_Object -------------- \n" \
      "5 запросов созданные для проверки LINQ\n" \
      "1. Вывести список всех пациентов\n" \
      "2. Вывести всех пациентов у которых опасность совпадает с типом комнаты \n" \
      "3. Вывести средную опасность пациентов \n" \
      "4. Вывести количество пациентов на 6 этаже \n" \
      "5. Вывести пациента и доктора \n" \
      "\n--------- LINQ_to_JSON -------------- \n" \
      "6. Запись в JSON документ. \n" \
      "7. Чтение из JSON документа. \n" \
      "8. Обновление JSON документа. \n" \
      "--------- LINQ_to_SQL -------------- \n" \
      "\nСоздать классы сущностей, которые моделируют таблицы Вашей базы данных\n" \
      "9. Однотабличный запрос на выборку. (Вывести название пациента)\n" \
      "10. Многотабличный запрос на выборку. (Вывести название пациентов и докторов)\n" \
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
        f'postgresql://postgres:postgres@localhost:5432/',
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