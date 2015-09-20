__author__ = 'gsriniv1'

import postgresql.driver as pg_driver
import Modality

def ConnecttoDB():
    host='denalidev.c7arb5e6jrs8.us-west-2.rds.amazonaws.com'
    user='denalidev'
    password='kW8VJAcjYmPBA2'
    port=5432
    database='tutor'
    db=pg_driver.connect( user=user, password=password, host=host, port=port, database=database)
    return db

databasecon = ConnecttoDB()

print("------------------------")
m = Modality.Modality()
m.Name = "Sitar"
m.SaveToDatabase(databasecon)
m.Show()
print("------------------------")

modalities=Modality.Modalities()
modalities.LoadFromDatabase(databasecon)
modalities.ShowAll()

databasecon.close()




