from email import header
from russian_names import RussianNames
import csv
import random

params = {
    "number_patient": 5000,
    "number_rooms": 1500,
    "number_doctors": 2000,
} 

def generate_patient():
    header = ['id', 'surname', 'name', 'patronymic', 'height', 'weight', 'room number', 'degree of danger']
    with open('./tables/patient.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_patient']):
            name, patronymic, surname = RussianNames().get_person().split()
            height = random.randint(150, 200)
            weight = random.randint(30, 200)
            room_number = random.randint(1, params["number_rooms"])
            degree_of_danger = random.randint(0, 10)
            
            data = [i, surname, name, patronymic, height, weight, room_number, degree_of_danger]
            writer.writerow(data)


def generate_doctors():
    header = ['id', 'surname', 'name', 'patronymic', 'medical speciality', 'role']
    
    speciality = ['невролог', 'психиатор', 'психолог', 'без специальности', 'хирург', 'терапевт']
    role = ['врач', 'лечащий врач', 'ассистент', 'медсестра']
    
    with open('./tables/doctor.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_doctors']):
            name, patronymic, surname = RussianNames().get_person().split()
            speciality_nubmer = random.randint(0, len(speciality) - 1)
            role_number = random.randint(0, len(role) - 1)
            
            data = [i, surname, name, patronymic, speciality[speciality_nubmer], role[role_number]]
            writer.writerow(data)
            

def generate_rooms():
    header = ['number', 'floor', 'number of beds', 'room type', 'number of patients']
    
    with open('./tables/room.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_rooms']):
            floor = random.randint(1, 10)
            number_of_beds = random.randint(1, 6)
            room_type = random.randint(0, 10)
            number_of_patients = random.randint(0, number_of_beds)
            
            data = [i, floor, number_of_beds, room_type, number_of_patients]
            writer.writerow(data)


def generate_diseases():
    header = ['number', 'floor', 'number of beds', 'room type', 'number of patients']
    
    with open('./tables/room.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_rooms']):
            floor = random.randint(1, 10)
            number_of_beds = random.randint(1, 6)
            room_type = random.randint(0, 10)
            number_of_patients = random.randint(0, number_of_beds)
            
            data = [i, floor, number_of_beds, room_type, number_of_patients]
            writer.writerow(data)


def main():
    generate_rooms()


if __name__ == "__main__":
    main()
