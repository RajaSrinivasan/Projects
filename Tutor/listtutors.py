__author__ = 'srini'
from tutordbsetup import Modality, Person, Tutor, listtutors
#from flask import Flask
#app = Flask(__name__)

tutors = listtutors()
print(len(tutors))
for t in tutors:
    print(t.id, " ", t.personid, t.modalityid1)