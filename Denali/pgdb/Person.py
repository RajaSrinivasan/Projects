__author__ = 'gsriniv1'
import postgresql.driver as pg_driver

class Person:

    def __init__(self):
        pass

    def __get__(self, obj, objtype):
    #    print('retrieving ', self.name)
        return self.val

    def __set__(self,obj,val):
        print('Updating')

    def __delete__(self,obj):
        if self.fdel is None:
            raise AttributeError("Cant delete attribute")
        self.fdel(obj)

    def Show(self):
        #If n < len(self):
        print("---------------------")
        print("ID=",self.ID," Name=", self.FirstName , self.LastName, "City " , self.City , "Phone1 " , self.Ph1, "Phone2" , self.Ph2 , "EMail1 " , self.Email1 )


    def SaveToDatabase(self,db):
        nextidstmt='SELECT max("ID") from people'
        nextid=db.prepare(nextidstmt)
        maxid='0'
        for row in nextid:
            maxid=row[0]
        #print(maxid)
        newid=int(maxid)+1
        self.ID=newid
        sqlstmt="INSERT INTO people (" + '"ID" , "Name"' + ") values (" + str(self.ID) + ', ' + "'" + self.Name  + "' )"
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
            newperson.ID=row["ID"]
            newperson.FirstName=row["Name"][0]
            newperson.LastName=row["Name"][1]
            newperson.Addr=row["Address"]
            newperson.City=row["City"]
            phone=row["Phone"]
            if not phone is None:
                if len(phone) > 0:
                    newperson.Ph1 = phone[0]
                if len(phone) > 1:
                    newperson.Ph2 = phone[1]
                else:
                    newperson.Ph2 = None
            else:
                newperson.Ph1 = phone
                newperson.Ph2 = phone
            
            newperson.Email1=row["Email"]
            self.all.append(newperson)


    def ShowAll(self):
        for obj in self.all:
            obj.Show()

