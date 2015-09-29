__author__ = 'gsriniv1'
import tutordatabase
import postgresql.driver as pg_driver
import Person
import Teacher
import sys


databasecon = tutordatabase.ConnecttoDB()

print("------------------------")
t=Teacher.Teachers()

t.LoadFromDatabase(databasecon)
t.ShowAll()

databasecon.close()

