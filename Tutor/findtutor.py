__author__ = 'srini'

from tutordbsetup import Modality, Person, Tutor, findtutor
#from flask import Flask
#app = Flask(__name__)

tutor = findtutor(14)
tutor[0].show()
tutor[1].show()


