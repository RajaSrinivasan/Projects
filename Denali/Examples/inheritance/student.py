__author__ = 'srini'
import person
class Student(person.Person):
    def __init__(self):
        super(Student,self).__init__()

    def Show(self):
        super(Student,self).Show()
        print("I am a student")