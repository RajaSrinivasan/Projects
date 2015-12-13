__author__ = 'srini'

from tutordbsetup import Modality, Person, Tutor, findtutor
#from flask import Flask
#app = Flask(__name__)

tutor = findtutor(7)
tutor[0].show()
tutor[1].show()


