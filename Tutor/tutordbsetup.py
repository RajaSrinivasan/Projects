
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

#Config end
#####Insert at end of file
Base = declarative_base()

#************************************


#Class Represents our tables
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

class Person(Base):
    # Table represents table in DB
    __tablename__ = 'person'

    #Mapper connnects DB cols to class
    id = Column(Integer, primary_key = True)
    firstname = Column(String(20), nullable = False)
    lastname = Column(String(20), nullable = False)
    address1 = Column(String(40), nullable = True)
    address2 = Column(String(40), nullable = True)
    city= Column(String(20), nullable = False)
    state = Column(String(20), nullable = False)
    zip = Column(String(10), nullable = True)
    email = Column(String(40), nullable = True)
    phone1 = Column(String(15), nullable = True)
    phone2 = Column(String(15), nullable = True)

    def __str__(self):
        return "firstname = %s lastname = %s " %  (self.firstname, self.lastname)

    def setProperties(self,props):
        self.firstname=props["firstname"]
        self.lastname=props["lastname"]
        if "address1" in props:
            self.address1 = props["address1"]
        else:
            self.address1=""
        if "address2" in props:
            self.address2 = props["address2"]
        else:
            self.address2=""
        self.city=props["city"]
        self.state=props["state"]
        if "zip" in props:
            self.zip = props["zip"]
        else:
            self.zip=""
        if "email" in props:
            self.email = props["email"]
        else:
            self.email=""
        if "phone1" in props:
            self.phone1 = props["phone1"]
        else:
            self.phone1=""
        if "phone2" in props:
            self.phone2 = props["phone2"]
        else:
            self.phone2=""
        print("finished setting props")

    def addtoDB(self):
        session.add(self)
        print("Added person to DB")

class Tutor(Base):
    __tablename__ = 'tutor'
    id = Column(Integer, primary_key = True)
    personid = Column(Integer, ForeignKey('person.id'))
    tchoverinternet = Column(String(1), nullable = False)
    website = Column(String(80), nullable=True)
    genre = Column(String(100), nullable = True)
    modalityid1 = Column(Integer, ForeignKey('modality.id'))
    modalityid2 = Column(Integer, ForeignKey('modality.id'))
    person = relationship(Person)
    modalityrel1 = relationship("Modality", foreign_keys=[modalityid1])
    modalityrel2 = relationship("Modality", foreign_keys=[modalityid2])

    def __str__(self):
        return "id = %d modalityid1 = %d genre = %s " % (self.id,self.modalityid1,self.genre)

    def setPerson(self,person):

        session.flush()
        self.personid=person.id
        print("set personid complete ", self.personid)

    def addtoDB(self):
        session.add(self)
        print("add to tutor db complete")

    def setProperties(self,tprops):
        self.tchoverinternet = tprops["tchoverinternet"]
        if "website" in tprops:
            self.website = tprops["website"]
        else:
            self.website=""
        if "genre" in tprops:
            self.genre = tprops["genre"]
        else:
            self.genre=""
        if "modality1" in tprops:
            self.modalityid1 = getmodid(tprops["modality1"])
        else:
            self.modalityid1=0
        if "modality2" in tprops:
            self.modalityid1 = getmodid(tprops["modality2"])
        else:
            self.modalityid2=0
        print("set tutor props complete")

def listtutors():
    items = (session.query(Person, Tutor, Modality)
            .filter(Person.id == Tutor.personid)
            .filter(Tutor.modalityid1==Modality.id)
            .order_by(Person.id)
            ).all()
    return items

'''
    @property
    def serialize(self):
        return {
            'name': self.name,
            'id' : self.id
        }
'''

#************************************


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

def getmodid(name):
    item = session.query(Modality).filter_by(name=name).one()
    print("modid= ", item.id, name)
    return item.id

engine = create_engine('sqlite:///tutor.db')
Base.metadata.bind = engine
Base.metadata.create_all(engine)

DBSession = sessionmaker(bind=engine)
session = DBSession()