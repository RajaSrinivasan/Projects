__author__ = 'srini'
class Person:
    def __init__(self):
        self._name="Unknown"

    def setName(self,name):
        self._name=name

    def Show(self):
        print("I am a person and my name is " , self._name)


    def __get__(self, obj, objtype):
    #    print('retrieving ', self.name)
        return self.val

    def __set__(self,obj,val):
        print('Updating')

    def __delete__(self,obj):
        if self.fdel is None:
            raise AttributeError("Cant delete attribute")
        self.fdel(obj)