__author__ = 'srini'
class Person:
    def __init__(self):
        self._name="Unknown"

    def setName(self,name):
        self._name=name

    def Show(self):
        print(self._name)
