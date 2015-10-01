__author__ = 'gsriniv1'
import tutordatabase
import postgresql.driver as pg_driver
import Person
import Teacher
import sys


databasecon = tutordatabase.ConnecttoDB()

print("------------------------")
t=Teacher.Teachers()

#t.LoadFromDatabase(databasecon)
#t.ShowAll()


#***Save to DB

st=Teacher.Teacher()
newid=st.GetNextID(databasecon)
print(newid)

st.setID(newid)
st.setName("Test", "Teacher")
st.setDetails(address="abc st",city="Waltham",email="x@gmail.com")
st.setTeacherDetails(modality=1, teachoverinternet="Y")

st.Show()
st.SaveToDatabase(databasecon)
databasecon.close()

