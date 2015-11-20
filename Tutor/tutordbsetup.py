
"""
This module is designed to be imported by all applications.
"""
import sys
from flask import Flask,jsonify
#Config - Import sqlalchemy modules and instantiate declarative_base
from sqlalchemy import Column, ForeignKey, Integer, String

from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import relationship, sessionmaker

from sqlalchemy import create_engine


Base = declarative_base()

#Class Represents our tables

class Person(Base):
    # Table represents table in DB
    __tablename__ = 'person'

    #Mapper connnects DB cols to class
    id = Column(Integer, primary_key = True)
    firstname = Column(String(20), nullable = False)
    lastname = Column(String(20), nullable = False)
    address1 = Column(String(40), nullable = False)
    address2 = Column(String(40), nullable = False)
    city= Column(String(20), nullable = False)
    state = Column(String(20), nullable = False)
    zip = Column(String(10), nullable = False)
    email = Column(String(40), nullable = False)
    phone = Column(String(15), nullable = False)

class Tutor(Base):
    __tablename__ = 'tutor'
    id = Column(Integer, primary_key = True)
    personid = Column(Integer, ForeignKey('person.id'))
    internet = Column(String(1), nullable = False)
    genre = Column(String(20), nullable = False)
    person = relationship(Person)

class Student(Base):
    __tablename__ = 'student'
    id = Column(Integer, primary_key = True)
    personid = Column(Integer, ForeignKey('person.id'))
    tutorid = Column(Integer, ForeignKey('tutor.id'))
    person = relationship(Person)
    tutor = relationship(Tutor)
'''
    @property
    def serialize(self):
        return {
            'name': self.name,
            'id' : self.id
        }
'''

class Modality(Base):
    __tablename__ = 'modality'
    id = Column(Integer, primary_key = True)
    name = Column(String(80), nullable = False)
    @property
    def serialize(self):
        return {
            'name': self.name,
            'id' : self.id
        }

#Config end
#####Insert at end of file

engine = create_engine('sqlite:///tutor.db')
Base.metadata.bind = engine
Base.metadata.create_all(engine)

DBSession = sessionmaker(bind=engine)
session = DBSession()

def addmodality(name):
    modality = Modality(name=name)
    session.add(modality)
    session.commit()

def listmodalities():
    items = session.query(Modality).all()
    return items

def listmodalitiesJSON():
     allm = listmodalities()
     return jsonify(Modalities=[i.serialize for i in allm])

def editmodality(id, name):
    item = session.query(Modality).filter_by(id=id).one()
    item.name = name
    session.add(item)
    session.commit()

def deletemodality(id):
    try:
        item = session.query(Modality).filter_by(id=id).one()
        mname=item.name
        session.delete(item)
        session.commit()
    except:
        pass

def getmodname(id):
    item = session.query(Modality).filter_by(id=id).one()
    return item.name