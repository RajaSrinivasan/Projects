__author__ = 'srini'
from flask import Flask, render_template, request, redirect, url_for, jsonify, flash
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
        flash("New Modality %s Added" % name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        return render_template('addnewmodality.html')

@app.route("/modalities/edit/<int:m_id>/",methods = ['GET','POST'])
def rt_editmodality(m_id):
    if request.method == 'POST':
        m_name = request.form['editmod']
        m_id = request.form['mid']
        tutordbsetup.editmodality(m_id,m_name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        mname = tutordbsetup.getmodname(m_id)
        return render_template('editmodality.html',eid=m_id,ename=mname)

@app.route("/modalities/delete/<int:m_id>/",methods = ['GET','POST'])
def rt_deletemodality(m_id):
    if request.method == 'POST':
        m_name = request.form['delmod']
        m_id = request.form['mid']
        tutordbsetup.deletemodality(m_id)
        flash("Modality %s Deleted" % m_name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        mname = tutordbsetup.getmodname(m_id)
        return render_template('deletemodality.html',eid=m_id,ename=mname)

if __name__ == "__main__":
    app.secret_key = "supersecretkey"
    app.debug=True
    app.run(host="0.0.0.0", port=5010)
