__author__ = 'gsriniv1'
import Person

class Teacher(Person.Person):
    def __init__(self):
        super(Teacher,self).__init__()
        self.setTeacherDetails()

    def setTeacherDetails(self, modality = 0, bio="unknown", website="unknown", teachoverinternet="N"):
        self._Modality =modality
        self._Bio = bio
        self._Website = website
        self._TeachOverInternet = teachoverinternet

    def Show(self):
        super(Teacher,self).Show()
        print("---------Modality=",self._Modality, "Bio=",self._Bio,"Website=",self._Website, "TeachOverInternet=",self._TeachOverInternet)

    def SaveToDatabase(self,db):
        super(Teacher,self).SavetoDatabase(db)
        #insert into people ("ID", "Name") values ('5', '{{Durga}, {Krishnan}}')
        #insert into teacher ("ID", "Instrumentid") values ('5', '{{Durga}, {Krishnan}}')
        sqlstmt="INSERT INTO teacher (" + '"ID" , "Name" ' + ") values (" + str(self.ID) + ",'{" + self.FirstName  + "," + self.LastName + "}' )"
        print(sqlstmt)
        db.execute(sqlstmt)

class Teachers():

    def __init__(self):
            self.all=[]

    def LoadFromDatabase(self,db):
        allteacherssql='SELECT * from teacher t, people p where t."ID" = p."ID"'
        preps=db.prepare(allteacherssql)
        for row in preps:
            # attributes of all persons.
            newteacher=Teacher()
            newteacher.setID(row["ID"])
            newteacher.setName(row["Name"][0],row["Name"][1])
            newteacher.setDetails(address=row["Address"],city=row["City"],email=row["Email"])

            #from teacher table, attributes specific to a teacher
            newteacher.setTeacherDetails(modality=row["Modality"], bio=row["Bio"], website=row["Website"], teachoverinternet=row["TeachOverInternet"])
            self.all.append(newteacher)


    def ShowAll(self):
        for obj in self.all:
            obj.Show()
