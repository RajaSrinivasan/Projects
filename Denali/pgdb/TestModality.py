__author__ = 'gsriniv1'
import tutordatabase
import postgresql.driver as pg_driver
import Modality
import sys


databasecon = tutordatabase.ConnecttoDB()

print("------------------------")
m = Modality.Modality()
m.Name = "Flute"
m.SaveToDatabase(databasecon)
m.Show()
print("------------------------")

modalities=Modality.Modalities()
modalities.LoadFromDatabase(databasecon)
modalities.ShowAll()

databasecon.close()




