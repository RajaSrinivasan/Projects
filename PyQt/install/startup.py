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
        print("Connect to the console %s" % self.ui.txtConsoleIPAddress.text())
        self.ui.done(1)