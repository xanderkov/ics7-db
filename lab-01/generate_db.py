from email import header
from russian_names import RussianNames
import csv
import random
import wonderwords

params = {
    "number_patient": 5000,
    "number_rooms": 1500,
    "number_doctors": 2000,
    "number_of_diseases": 1200,
    "number_of_medicine": 4000,
} 

def generate_patient():
    header = ['surname', 'name', 'patronymic', 'height', 'weight', 'room number', 'degree of danger']
    with open('./tables/patient.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_patient']):
            name, patronymic, surname = RussianNames().get_person().split()
            height = random.randint(150, 200)
            weight = random.randint(30, 200)
            room_number = random.randint(1, params["number_rooms"])
            degree_of_danger = random.randint(0, 10)
            
            data = [surname, name, patronymic, height, weight, room_number, degree_of_danger]
            writer.writerow(data)


def generate_doctors():
    header = ['surname', 'name', 'patronymic', 'medical speciality', 'role']
    
    speciality = ['невролог', 'психиатор', 'психолог', 'без специальности', 'хирург', 'терапевт']
    role = ['врач', 'лечащий врач', 'ассистент', 'медсестра']
    
    with open('./tables/doctor.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_doctors']):
            name, patronymic, surname = RussianNames().get_person().split()
            speciality_nubmer = random.randint(0, len(speciality) - 1)
            role_number = random.randint(0, len(role) - 1)
            
            data = [surname, name, patronymic, speciality[speciality_nubmer], role[role_number]]
            writer.writerow(data)
            

def generate_rooms():
    header = ['floor', 'number of beds', 'room type', 'number of patients']
    
    with open('./tables/room.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(1, params['number_rooms'] + 1):
            floor = random.randint(1, 10)
            number_of_beds = random.randint(1, 6)
            room_type = random.randint(0, 10)
            number_of_patients = random.randint(0, number_of_beds)
            
            data = [floor, number_of_beds, room_type, number_of_patients]
            writer.writerow(data)


def generate_diseases():
    header = ['name', 'symptoms', 'reasons', 'diagnosis', 'classification']
    def generate_diseases():
        header = ['name', 'symptoms', 'reasons', 'diagnosis', 'classification']
    
    with open('./tables/mental.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_of_diseases']):
            
            name = wonderwords.RandomWord().word() + ' ' + wonderwords.RandomWord().word()
            syptoms = wonderwords.RandomSentence().sentence()
            reasons = wonderwords.RandomSentence().sentence()
            diagnosis = wonderwords.RandomSentence().sentence()
            classification = random.randint(0, 100)
            
            data = [name, syptoms, reasons, diagnosis, classification]
            writer.writerow(data)


def generate_medicines():
    header = [ 'name', 'expiration date', 'recipe', 'contraindications', 'side effects']
    
    with open('./tables/medicines.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(params['number_of_medicine']):
            
            name = wonderwords.RandomWord().word() + ' ' + wonderwords.RandomWord().word() + ' ' + wonderwords.RandomWord().word() + ' ' + wonderwords.RandomWord().word()
            
            expiration_data =  str(random.randint(2022, 2030)) + '-' + str(random.randint(1, 12)) + '-' + str(random.randint(1, 28))
            recipe = wonderwords.RandomSentence().sentence()
            contraindications = wonderwords.RandomSentence().sentence()
            side_effects = wonderwords.RandomSentence().sentence()
            
            data = [name, expiration_data, recipe, contraindications, side_effects]
            writer.writerow(data)

def generate_relations(table_name, n, m):
    header = ['idn', 'idm']
    
    with open(table_name, 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        
        writer.writerow(header)
        
        for i in range(n):
            
            idm = random.randint(1, m)
            data = [i + 1, idm]
            writer.writerow(data)
            

def main():
    generate_diseases()
    generate_doctors()
    generate_medicines()
    generate_patient()
    generate_rooms()
    generate_relations('./tables/doctor_patient.csv', params['number_patient'], params['number_doctors'] - 1)
    generate_relations('./tables/medicenes_patient.csv', params['number_patient'], params['number_of_medicine'] - 1)
    generate_relations('./tables/mental_patient.csv', params['number_patient'], params['number_of_diseases'] - 1)
    
    
if __name__ == "__main__":
    main()
