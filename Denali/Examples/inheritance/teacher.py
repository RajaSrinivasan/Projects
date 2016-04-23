__author__ = 'srini'
import person
class Teacher(person.Person):
    def __init__(self):
        super(Teacher,self).__init__()

    def Show(self):
        super(Teacher,self).Show()
        print("I am a teacher")

class Teachers():
    def __init__(self):
        
