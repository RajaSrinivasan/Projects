__author__ = 'srini'
from tutordbsetup import Modality, listmodalities, listmodalitiesJSON
#from flask import Flask
#app = Flask(__name__)

ms = listmodalities()
for m in ms:
    print(m.name, "", m.id)

