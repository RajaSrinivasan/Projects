__author__ = 'gsriniv1'
import postgresql.driver as pg_driver

class Person:

    def __init__(self):
        self._ID=0
        self._FirstName="Unknown"
        self._LastName="Unknown"
        self._Phone="Unknown"
        self._Email="Unknown"
        self._Address="Unknown"
        self._City="Unknown"

    def setID(self,ID):
        self._ID=ID

    def getID(self):
        return self._ID

    def setName(self,firstname,lastname):
        self._FirstName=firstname
        self._LastName=lastname

    def getName(self):
        return self._FirstName,self._LastName

    def setDetails(self,phone="Unknown",email="Unknown",address="Unknown",city="Unknown"):
        self._Phone=phone
        self._Email=email
        self._Address=address
        self._City=city

    def Show(self):
        #If n < len(self):
        print("---------------------")
        print("ID=",self._ID," Name=", self._FirstName , self._LastName )
        print("---------City=",self._City, "Address=",self._Address,"Email=",self._Email)

    def GetNextID(self,db):
        nextidstmt='SELECT max("ID") from people'
        nextid=db.prepare(nextidstmt)
        maxid='0'
        for row in nextid:
            maxid=row[0]
        #print(maxid)
        newid=int(maxid)+1
        return newid

    def SaveToDatabase(self,db):
        #insert into people ("ID", "Name") values ('5', '{{Durga}, {Krishnan}}')
        sqlstmt="INSERT INTO people (" + '"ID" , "Name" ' + ") values (" + str(self._ID) + ",'{" + self._FirstName  + "," + self._LastName + "}' )"
        print(sqlstmt)
        db.execute(sqlstmt)


class Persons:
    def __init__(self):
        self.all=[]

    def LoadFromDatabase(self,db):
        allpersonssql='SELECT * from people'
        preps=db.prepare(allpersonssql)
        for row in preps:
            newperson=Person()
            newperson.setID(row["ID"])
            newperson.setName(row["Name"][0],row["Name"][1])
            newperson.setDetails(address=row["Address"],city=row["City"],email=row["Email"])
            self.all.append(newperson)


    def ShowAll(self):
        for obj in self.all:
            obj.Show()

