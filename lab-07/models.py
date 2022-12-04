from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, ForeignKey, Text, Numeric, CheckConstraint, Date, JSON, Varchar
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
    room_number = Column(Integer, nullable=False)
    degree_of_danger = Column(Integer, nullable=False)
    room_number = Column(Integer, ForeignKey('rooms.number'))
    
    
class Rooms(BASE):
    __tablename__ = 'rooms'
    __table_args__ = {"schema": "public"}
    number = Column(Integer, primary_key=True)
    type = Column(Text, nullable=False)
    patients = relationship("Patients", back_populates="rooms")