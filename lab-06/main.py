from db import MentalHospital

MSGS = "Меню\n\n"\
       "1. Выполнить скалярный запрос\n"\
       "2. Выполнить запрос с несколькими соединениями (JOIN)\n"\
       "3. Выполнить запрос с OTB(CTE) и оконными функциями\n"\
       "4. Выполнить запрос к метаданным\n"\
       "5. Вызвать скалярную функцию (написанную в третьей лабораторной работе)\n"\
       "6. Вызвать многооператорную или табличную функцию (написанную в третьей лаборатнрной работе)\n"\
       "7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе)\n"\
       "8. Вызвать системную функцию или процедуру\n"\
       "9. Создать таблицу в базе данных, соотвествующую тематике БД\n"\
       "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY\n"\
       "0. Выход\n"\
       "Выбор: "\

def input_command():
    try:
        command = int(input(MSGS))
    except:
        command = -1
    
    if command < 0 or command > 10:
        print("Ожидался ввод числа от 0 до 10\n")
    
    return command

def main():
    mh = MentalHospital()
    command = -1
    
    while command != 0:
        command = input_command()
        
        if command == 1:
            mh.get_scalar_query()
        elif command == 2:
            mh.get_join_query()
        elif command == 3:
            mh.get_otb_query()
        elif command == 4:
            mh.get_metadata_query()
        elif command == 5:
            mh.get_scalar_function()
        elif command == 6:
            mh.call_multi_operator_function()
        elif command == 7:
            mh.get_stored_procedure()
        elif command == 8:
            mh.get_system_function()
        elif command == 9:
            mh.create_table()
        elif command == 10:
            mh.insert_data()
        else:
            continue
        #mh.print_table()
        
if __name__ == "__main__":
    main()
