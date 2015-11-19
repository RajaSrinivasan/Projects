__author__ = 'srini'
from flask import Flask, render_template, request, redirect, url_for, jsonify
import tutordbsetup

app = Flask(__name__)

@app.route("/")
@app.route("/modalities")
def rt_modalities():
     allm = tutordbsetup.listmodalities()
     return render_template('modalities.html',allm=allm)

@app.route("/modalities/JSON")
def rt_modJSON():
     allrest = RestaurantSite.rawlistofrestaurants()
     return jsonify(Restaurants=[i.serialize for i in allrest])


@app.route('/modalities/new',methods = ['GET','POST'])
def rt_addmodolity():
    if request.method == 'POST':
        name = request.form['t_mnam']
        tutordbsetup.addmodality(name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        return render_template('addnewmodality.html')

if __name__ == "__main__":
    app.secret_key = "supersecretkey"
    app.debug=True
    app.run(host="0.0.0.0", port=5010)
