#!/usr/bin/env python
from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QDialog)
from PyQt5 import uic

class ConsoleIP(QDialog):
    def __init__(self):
        super().__init__()
        ipadrrexp = QRegExp("\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}")
        ipadrvalidator = QRegExpValidator(ipadrrexp)

        self.ui = uic.loadUi("NetInstall.ui")
        self.ui.txtConsoleIPAddress.setValidator(ipadrvalidator)

        self.ui.btnCancel.clicked.connect(self.CancelClicked)
        self.ui.btnConnect.clicked.connect(self.ConnectClicked)
        self.ui.show()

    @pyqtSlot()
    def CancelClicked(self):
        self.ui.done(0)

    @pyqtSlot()
    def ConnectClicked(self):
        print("Connect to %s" % self.ui.txtConsoleIPAddress.text())

class Hello(QWidget):

    def __init__(self):
        super().__init__()
        self.Init()

    def Init(self):

        self.setGeometry(300, 300, 300, 220)
        self.setWindowTitle('Hello Srini')

        btn = QPushButton('Cancel', self)
        btn.resize(btn.sizeHint())
        btn.move(50, 50)
        btn.clicked.connect(QCoreApplication.instance().quit)

        btn = QPushButton('Continue', self)
        btn.setToolTip('This is a <b>QPushButton</b> widget')
        btn.resize(btn.sizeHint())
        btn.move(150, 50)
        self.show()



if __name__ == '__main__':
    import sys

    app = QApplication(sys.argv)
    w = ConsoleIP()
    sys.exit(app.exec_())