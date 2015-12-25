from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QDialog)
from PyQt5 import uic

class ConnectionStatus(QDialog):
    def __init__(self):
        super().__init__()
        self.ui = uic.loadUi("ConnectionStatus.ui")

        self.ui.btnBack.clicked.connect(self.BackClicked)
        self.ui.btnProceed.clicked.connect(self.ProceedClicked)
        self.ui.show()

    @pyqtSlot()
    def BackClicked(self):
        self.ui.done(0)

    @pyqtSlot()
    def ProceedClicked(self):
        print("Proceed")
        self.ui.done(1)