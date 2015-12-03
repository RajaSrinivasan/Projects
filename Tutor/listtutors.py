__author__ = 'srini'
from tutordbsetup import Modality, Person, Tutor, listtutors
#from flask import Flask
#app = Flask(__name__)

tutors = listtutors()
print(len(tutors))

for t in tutors:
    print(t[0], t[1])

    #print(t[0].firstname, t[1].modalityid1)
