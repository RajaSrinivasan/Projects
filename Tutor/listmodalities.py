__author__ = 'srini'
from tutordbsetup import Modality, listmodalities, listmodalitiesJSON
#from flask import Flask
#app = Flask(__name__)

ms = listmodalities()
for m in ms:
    print(m.name, "", m.id)

#
# @app.route("/modalities/JSON")
# def printjson():
#     print(listmodalitiesJSON())
#
# app.secret_key = "supersecretkey"
# app.debug=True
# app.run(host="0.0.0.0", port=5010)