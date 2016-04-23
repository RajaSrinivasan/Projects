__author__ = 'gsriniv1'
import postgresql.driver as pg_driver
import Modality
import Person

def ConnecttoDB():
    host='denalidev.c7arb5e6jrs8.us-west-2.rds.amazonaws.com'
    user='denalidev'
    password='kW8VJAcjYmPBA2'
    port=5432
    database='tutor'
    db=pg_driver.connect( user=user, password=password, host=host, port=port, database=database)
    return db


databasecon = ConnecttoDB()

p= Person.Person()
newid=p.GetNextID(databasecon)
p.setID(newid)
p.setName("Raman","VK")
p.Show()
p.SaveToDatabase(databasecon)

persons=Person.Persons()
persons.LoadFromDatabase(databasecon)
persons.ShowAll()
databasecon.close()

