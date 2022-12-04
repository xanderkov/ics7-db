from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, ForeignKey, Text, Numeric, CheckConstraint, Date, JSON
from sqlalchemy import PrimaryKeyConstraint

BASE = declarative_base()


class Patients(BASE):
    __tablename__ = 'patients'
    __table_args__ = {"schema": "public"}
    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    surname = Column(Text, nullable=False)
    patronymic = Column(Text, nullable=False)
    height = Column(Integer, nullable=False)
    weight = Column(Integer, nullable=False)
    room_number = Column(Integer, ForeignKey('rooms.number'))
    degree_of_danger = Column(Integer, nullable=False)
    
    room_number_rel = relationship("Rooms", foreign_keys=[room_number])
    
    
class Rooms(BASE):
    __tablename__ = 'rooms'
    __table_args__ = {"schema": "public"}
    number = Column(Integer, primary_key=True)
    floor = Column(Integer, nullable=False)
    number_of_beds = Column(Integer, nullable=False)
    room_type = Column(Integer, nullable=False)


class Doctors(BASE):
    __tablename__ = 'doctors'
    __table_args__ = {"schema": "public"}
    id = Column(Integer, primary_key=True)
    surname = Column(Text, nullable=False)
    name = Column(Text, nullable=False)


class Medicines(BASE):
    __tablename__ = 'Medicines'
    __table_args__ = {"schema": "public"}
    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    date = Column(Text, nullable=False)
    expiration_date = Column(Date, nullable=False)
    recipe = Column(Text, nullable=False)
    contraindications = Column(Text, nullable=False)
    side_effects = Column(Text, nullable=False)


class Mentals(BASE):
    __tablename__ = 'mentals'
    __table_args__ = {"schema": "public"}
    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    symptoms = Column(Text, nullable=False)
    reasons = Column(Text, nullable=False)
    diagnosis = Column(Text, nullable=False)
    classification = Column(Integer, nullable=False)


class DoctorPatient(BASE):
    __tablename__ = 'doctor_patient'
    __table_args__ = {"schema": "public"}
    doctor_number = Column(Integer, ForeignKey('doctors.id'), primary_key=True)
    patient_number = Column(Integer, ForeignKey('patients.id'), primary_key=True)


class PatientMental(BASE):
    __tablename__ = 'patient_mental'
    __table_args__ = {"schema": "public"}
    patient_number = Column(Integer, ForeignKey('patients.id'), primary_key=True)
    mental_number = Column(Integer, ForeignKey('mentals.id'), primary_key=True)


class MedicinePatient(BASE):
    __tablename__ = 'medicine_patient'
    __table_args__ = {"schema": "public"}
    medicine_number = Column(Integer, ForeignKey('medicines.id'), primary_key=True)
    patient_number = Column(Integer, ForeignKey('patients.id'), primary_key=True)
