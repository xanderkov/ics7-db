from time import time

import matplotlib.pyplot as plt
import psycopg2
import redis
import json
import threading
from random import randint

N_REPEATS = 5

def connection():
    # Подключаемся к БД.
    try:
        con = psycopg2.connect(
            database='mental_hospital',
            user='root',
            password='postgres',    
            host='127.0.0.1',
            port=5432
        )
    except:
        print("Ошибка при подключении к Базе Данных")
        return

    print("База данных успешно открыта")
    return con


# Написать запрос, получающий статистическую информацию на основе
# данных БД. 
# Пациент из 6 палаты
def get_dep1_workers(cur):
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    cache_value = redis_client.get("dep1_workers")
    if cache_value is not None:
        redis_client.close()
        return json.loads(cache_value)

    cur.execute("select * from patients where room_number = 6")
    res = cur.fetchall()

    redis_client.set("dep1_workers", json.dumps(res))
    redis_client.close()

    return res


# 1. Приложение выполняет запрос каждые 5 секунд на стороне БД.
def task_02(cur, id):
    threading.Timer(5.0, task_02, [cur, id]).start()

    cur.execute(f"select * from patients where room_number = {id}")

    result = cur.fetchall()

    return result


# 2. Приложение выполняет запрос каждые 5 секунд через Redis в качестве кэша.
def task_03(cur, id):
    threading.Timer(5.0, task_02, [cur, id]).start()

    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    cache_value = redis_client.get(f"dep{id}_workers")
    if cache_value is not None:
        redis_client.close()
        return json.loads(cache_value)

    cur.execute(f"select * from patients where room_number = {id}")

    result = cur.fetchall()
    data = json.dumps(result)
    redis_client.set(f"dep{id}_workers", data)
    redis_client.close()

    return result


def dont_do(cur):
    redis_client = redis.Redis()#host="localhost", port=6379, db=0)

    t1 = time()
    cur.execute("select * from patients where room_number = 6")
    t2 = time()

    result = cur.fetchall()

    data = json.dumps(result)
    cache_value = redis_client.get("w1")
    if cache_value is not None:
        pass
    else:
        redis_client.set("w1", data)

    t11 = time()
    redis_client.get("w1")
    t22 = time()

    redis_client.close()

    return t2 - t1, t22 - t11


def del_worker(cur, con):
    redis_client = redis.Redis()

    wid = randint(1, 1000)

    t1 = time()
    cur.execute(f"delete from doctor_patient where patient_number = {wid};")
    cur.execute(f"delete from medicines_patient where patient_number = {wid};")
    cur.execute(f"delete from mental_patient where patient_number = {wid};")
    cur.execute(f"delete from patients where id = {wid};")
    t2 = time()

    t11 = time()
    redis_client.delete(f"w{wid}")
    t22 = time()

    redis_client.close()

    con.commit()

    return t2 - t1, t22 - t11


def ins_worker(cur, con):
    redis_client = redis.Redis()

    wid = 1

    t1 = time()
    cur.execute(f"INSERT INTO doctors (surname, name, patronymic, medical_speciality, role) "
                f"VALUES ('Иванов', 'Иван', 'Иванович', 'Хирург', 'Главный врач');")
    t2 = time()

    cur.execute(f"select * from doctors where id = {wid}")
    result = cur.fetchall()

    data = json.dumps(result)
    t11 = time()
    redis_client.set(f"w{wid}", data)
    t22 = time()

    redis_client.close()

    con.commit()

    return t2 - t1, t22 - t11


def upd_worker(cur, con):
    redis_client = redis.Redis()
    # print("update\n")
    # threading.Timer(10.0, upd_tour, [cur, con]).start() 

    wid = randint(1, 1000)

    t1 = time()
    cur.execute(f"UPDATE patients SET weight = 100 WHERE weight = {wid}")
    t2 = time()

    cur.execute(f"select * from patients where weight = {wid};")

    result = cur.fetchall()
    data = json.dumps(result)

    t11 = time()
    redis_client.set(f"w{wid}", data)
    t22 = time()

    redis_client.close()

    con.commit()

    return t2 - t1, t22 - t11


# гистограммы
def task_04(cur, con):
    # simple 
    t1 = 0
    t2 = 0
    for i in range(N_REPEATS):
        print(i)
        b1, b2 = dont_do(cur)
        t1 += b1
        t2 += b2
    print("simple 100 db redis", t1 / N_REPEATS, t2 / N_REPEATS)
    index = ["БД", "Redis"]
    values = [t1 / N_REPEATS, t2 / N_REPEATS]
    plt.bar(index, values)
    plt.title("Без изменения данных")
    plt.show()

    # delete 
    t1 = 0
    t2 = 0
    for i in range(N_REPEATS):
        print(i)
        b1, b2 = del_worker(cur, con)
        t1 += b1
        t2 += b2
    print("delete 100 db redis", t1 / N_REPEATS, t2 / N_REPEATS)

    index = ["БД", "Redis"]
    values = [t1 / N_REPEATS, t2 / N_REPEATS]
    plt.bar(index, values)
    plt.title("При добавлении новых строк каждые 10 секунд")
    plt.show()

    # insert 
    t1 = 0
    t2 = 0
    for i in range(N_REPEATS):
        print(i)
        b1, b2 = ins_worker(cur, con)
        t1 += b1
        t2 += b2
    print("ins_tour 100 db redis", t1 / N_REPEATS, t2 / N_REPEATS)

    index = ["БД", "Redis"]
    values = [t1 / N_REPEATS, t2 / N_REPEATS]
    plt.bar(index, values)
    plt.title("При удалении строк каждые 10 секунд")
    plt.show()

    # updata 
    t1 = 0
    t2 = 0
    for i in range(N_REPEATS):
        print(i)
        b1, b2 = upd_worker(cur, con)
        t1 += b1
        t2 += b2
    print("updata 100 db redis", t1 / N_REPEATS, t2 / N_REPEATS)

    index = ["БД", "Redis"]
    values = [t1 / N_REPEATS, t2 / N_REPEATS]
    plt.bar(index, values)
    plt.title("При изменении строк каждые 10 секунд")
    plt.show()


def do_cache(cur):
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    for wid in range(10000):
        cache_value = redis_client.get(f"w{wid}")
        if cache_value is not None:
            pass
            #print(f"{wid} exists")
            # redis_client.close()
            # return json.loads(cache_value)

        cur.execute(f"select *\
                    from patients\
                    where worker_id = {wid};")

        result = cur.fetchall()
        redis_client.set(f"w{wid}", json.dumps(result))
        redis_client.close()




if __name__ == '__main__':

    con = connection()
    cur = con.cursor()

    # do_cache(cur)
    #task_04(cur, con)

    print("1. Пациенты из 6 палаты (задание 2)\n"
          "2. Приложение выполняет запрос каждые 5 секунд на стороне БД. (задание 3.1)\n"
          "3. Приложение выполняет запрос каждые 5 секунд через Redis в качестве кэша. (задание 3.2)\n"
          "4. Гистограммы (задание 3.3)\n\n"
          )

    while True:
        c = int(input("Выбор: "))

        if c == 1:
            res = get_dep1_workers(cur)

            for elem in res:
                print(elem)

        elif c == 2:
            dep_id = int(input("Номер палаты: "))

            res = task_02(cur, dep_id)

            for elem in res:
                print(elem)

        elif c == 3:
            dep_id = int(input("Номер палаты:: "))

            res = task_03(cur, dep_id)

            for elem in res:
                print(elem)

        elif c == 4:
            task_04(cur, con)
            # draw_plots()
        else:
            print("Ошибка\n")
            break

    cur.close()