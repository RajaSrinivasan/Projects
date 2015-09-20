__author__ = 'gsriniv1'
import postgresql.driver as pg_driver

class Modality:

    def __init__(self):
        pass

    def __get__(self, obj, objtype):
        print('retrieving ', self.name)
        return self.val

    def __set__(self,obj,val):
        print('updating ', self.name)

    def __delete__(self,obj):
        if self.fdel is None:
            raise AttributeError("Cant delete attribute")
        self.fdel(obj)

    def Show(self):
        print("ID=",self.ID," Name=", self.Name)

    def SaveToDatabase(self,db):
        nextidstmt='SELECT max("ID") from modality'
        nextid=db.prepare(nextidstmt)
        maxid='0'
        for row in nextid:
            maxid=row[0]
        #print(maxid)
        newid=int(maxid)+1
        self.ID=newid
        sqlstmt="INSERT INTO modality (" + '"ID" , "Name"' + ") values (" + str(self.ID) + ', ' + "'" + self.Name  + "' )"
        print(sqlstmt)
        db.execute(sqlstmt)


class Modalities:
    def __init__(self):
        self.all=[]

    def LoadFromDatabase(self,db):
        allmodalitiessql='SELECT * from modality'
        preps=db.prepare(allmodalitiessql)
        for row in preps:
            newmodality=Modality()
            newmodality.ID=row["ID"]
            newmodality.Name=row["Name"]
            self.all.append(newmodality)

    def ShowAll(self):
        for obj in self.all:
            obj.Show()



