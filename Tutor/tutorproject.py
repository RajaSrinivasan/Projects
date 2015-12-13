__author__ = 'srini'
from flask import Flask, render_template, request, redirect, url_for, jsonify, flash
import tutordbsetup

app = Flask(__name__)

@app.route("/")

#***************************Tutors**************************
@app.route("/tutors")
def rt_tutors():
    alltutors = tutordbsetup.listtutors()
    return render_template('tutors.html',alltutors=alltutors)

@app.route('/tutors/new',methods = ['GET','POST'])
def rt_addtutor():
    if request.method == 'POST':
        try:
            personpropnames=['firstname','lastname','address1','address2','city','state','zip','phone1','phone2','email']
            tutorpropnames=['modality1','modality2', 'genre','tchoverinternet','website']
            props={}
            tprops={}
            for pp in personpropnames:
                props[pp] = request.form[pp]
                print(props[pp])

            print(len(props))
            person=tutordbsetup.Person()
            person.setProperties(props)
            person.addtoDB()

            for tp in tutorpropnames:
                tprops[tp] = request.form[tp]
                print(tp, ": ",tprops[tp])
            tutor=tutordbsetup.Tutor()
            print(" Next step- set props")
            tutor.setProperties(tprops)
            print(" Next step- set personid")
            tutor.setPerson(person)
            print(" Next step- add to db")
            tutor.addtoDB()

            tutordbsetup.session.commit()
            return redirect(url_for('rt_tutors',external=True))
        except:
            print ("Error")
            return redirect(url_for('rt_tutors',external=True))
    else:
        allm=tutordbsetup.listmodalities()
        person = tutordbsetup.Person()
        tutor = tutordbsetup.Tutor()
        mod = tutordbsetup.Modality()
        return render_template('tutor.html', allm=allm, person=person, tutor=tutor, mod=mod)

@app.route("/tutors/edit/<int:t_id>/",methods = ['GET','POST'])
def rt_edittutor(t_id):
    if request.method == 'POST':
        try:
            print("Edit Tutor function ", t_id)
            #name = request.form['name']
            #tutordbsetup.findtutor(t_id)
            return redirect(url_for('rt_tutors',external=True))
        except:
            print ("Error")
            return redirect(url_for('rt_tutors',external=True))
    else:
        tutor = tutordbsetup.findtutor(t_id)
        allm=tutordbsetup.listmodalities()
        return render_template('tutor.html', allm=allm, person=tutor[0], tutor=tutor[1], mod=tutor[2])

#***************************Modalities**************************
@app.route("/modalities")
def rt_modalities():
     allm = tutordbsetup.listmodalities()
     return render_template('modalities.html',allm=allm)

@app.route("/modalities/JSON")
def rt_modJSON():
     allm = tutordbsetup.listmodalities()
     return jsonify(Modalities=[i.serialize for i in allm])


@app.route('/modalities/new',methods = ['GET','POST'])
def rt_addmodality():
    if request.method == 'POST':
        name = request.form['name']
        tutordbsetup.addmodality(name)
        flash("New Modality %s Added" % name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        return render_template('modality.html',func="add")

@app.route("/modalities/edit/<int:id>/",methods = ['GET','POST'])
def rt_editmodality(id):
    if request.method == 'POST':
        name = request.form['name']
        id = request.form['id']
        tutordbsetup.editmodality(id,name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        name = tutordbsetup.getmodname(id)
        return render_template('modality.html',func="edit", id=id,name=name)

@app.route("/modalities/delete/<int:id>/",methods = ['GET','POST'])
def rt_deletemodality(id):
    if request.method == 'POST':
        #name = request.form['name']
        print(id)
        id = request.form['id']
        tutordbsetup.deletemodality(id)
        #flash("Modality %s Deleted" % name)
        return redirect(url_for('rt_modalities',external=True))
    else:
        name = tutordbsetup.getmodname(id)
        return render_template('modality.html',fun="del", id=id,name=name)

if __name__ == "__main__":
    app.secret_key = "supersecretkey"
    app.debug=True
    app.run(host="0.0.0.0", port=5010)
