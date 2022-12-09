import psycopg2

class MentalHospital:
    def __init__(self) -> None:
        try:
            self.__connecion = psycopg2.connect(
                database="mental_hospital",
                user="postgres",
                password="postgres",
                host="127.0.0.1",
                port="5432")
            self.__connecion.autocommit = True
            self._cursor = self.__connecion.cursor()
            self.table = []
            print("Успешное подключение к БД")
        except Exception as ex:
            print("Ошибка подключения к БД\n", ex)
            return
    
    def __del__(self):
        if self.__connecion:
            self._cursor.close()
            self.__connecion.close()
            print("Подключение к БД закрыто")
    
    def __sql_executer(self, sql):
        try:
            self._cursor.execute(sql)
            self.table = self._cursor.fetchall()
            print("Запрос выполнен")
            return True
        except Exception as ex:
            print("Ошибка выполнения запроса\n", ex)
            return False
    
    
    # 1. Скалярный запрос
    def get_scalar_query(self):
        print("Скалярный запрос. Количество пациентов в больнице:")
        sql_query = "SELECT COUNT(*) FROM patients"
        if self.__sql_executer(sql_query):
            print(self.table[0])
    
    # 2. Выполнить запрос с несколькими соединенимями (JOIN)
    def get_join_query(self):
        print("Запрос с несколькими соединениями (JOIN). Пациенты, которые лечатся в больнице у докторов:")
        sql_query = "SELECT * FROM patients \
        JOIN doctor_patient on patients.id = doctor_patient.patient_number\
        JOIN doctors ON doctor_patient.doctor_number = doctors.id"
        if self.__sql_executer(sql_query):
            for row in self.table:
                print(row)
    
    # 3. Выполнить запрос с OTB(CTE) и оконными функциями
    def get_otb_query(self):
        print("Запрос с OTB(CTE) и оконными функциями. Пациенты, которые лечатся в больнице у докторов:")
        sql_query = """WITH Three(Row, name) AS (
                        SELECT ROW_NUMBER() OVER(PARTITION BY table_name) as row, table_name as name
                        from information_schema.columns
                        where table_catalog = 'mental_hospital' 
                    and table_schema = 'public'

                    ) select distinct name, row from three where row > 2
                    GROUP BY name, row;"""
        if self.__sql_executer(sql_query):
            for row in self.table:
                print(row)
    
    # 4. Выполнить запрос к метаданным
    def get_metadata_query(self):
        print("Запрос к метаданным. Список таблиц:")
        sql_query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
        if self.__sql_executer(sql_query):
            for row in self.table:
                print(row)
    
    # 5. Вызвать скалярную функцию (написанную в третьей лабораторной работе)
    def get_scalar_function(self):
        print("Скалярная функция. Количество пациентов в больнице:")
        sql_query = "SELECT AvgDanger();"
        if self.__sql_executer(sql_query):
            print(self.table[0])
    
    # 6. Вызвать многооператорную или табличную функцию (написанную в третьей лаборатнрной работе)
    def call_multi_operator_function(self):
        print("Многооператорная или табличная функция. Пациенты, которые лечатся в больнице у докторов:")
        sql_query = "SELECT * FROM pdalot();"
        if self.__sql_executer(sql_query):
            for row in self.table:
                print(row)
    
    # 7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе)
    def get_stored_procedure(self):
        print("Хранимая процедура. Пациенты, которые лечатся в больнице у докторов:")
        sql_query = "CALL inspatients(); select surname from patients where id > 4999;"
        if self.__sql_executer(sql_query):
            for row in self.table:
                print(row)
    
    # 8. Вызвать системную функцию или процедуру
    def get_system_function(self):
        print("Системная функция или процедура. Текущее время:")
        sql_query = "a"
        if self.__sql_executer(sql_query):
            print(self.table[0])
    
    # 9. Создать таблицу в базе данных, соотвествующую тематике БД
    def create_table(self):
        print("Создание таблицы. Таблица докторов:")
        sql_query = """DROP TABLE IF EXISTS doctors CASCADE;
                    CREATE TABLE IF NOT EXISTS doctors
                    (
                        id INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                        surname VARCHAR(64),
                        name VARCHAR(64),
                        patronymic VARCHAR(64),
                        medical_speciality VARCHAR(20),
                        role VARCHAR(20)
                    );
                    
                    SELECT * FROM doctors;"""
        if self.__sql_executer(sql_query):
            print("Таблица создана")
    
    # 10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY
    def insert_data(self):
        print("Вставка данных в таблицу. Добавление докторов:")
        sql_query = """INSERT INTO doctors (surname, name, patronymic, medical_speciality, role) VALUES ('Иванов', 'Иван', 'Иванович', 'Хирург', 'Главный врач');\
                    INSERT INTO doctors (surname, name, patronymic, medical_speciality, role) VALUES ('Петров', 'Петр', 'Петрович', 'Терапевт', 'Врач');\
                    INSERT INTO doctors (surname, name, patronymic, medical_speciality, role) VALUES ('Сидоров', 'Сидор', 'Сидорович', 'Терапевт', 'Врач');
                    SELECT * FROM doctors where id > 1998;"""
        self.__sql_executer(sql_query)
    
    def print_table(self):
        for row in self.table:
            print(row)