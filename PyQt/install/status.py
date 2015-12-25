import PyQt5
from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QTableWidgetItem,
                             QDialog)
from PyQt5 import uic

class ConnectionStatus(QDialog):
    def __init__(self):
        super().__init__()
        self.ui = uic.loadUi("ConnectionStatus.ui")
        self.ui.tblStatus.setRowCount(4)

        hdritm = QTableWidgetItem("Item")
        self.ui.tblStatus.setHorizontalHeaderItem(0,hdritm)

        hdritm = QTableWidgetItem("Status")
        self.ui.tblStatus.setHorizontalHeaderItem(1,hdritm)

        # self.ui.tblStatus.setHorizontalHeaderLabels(["Item" , "Status"])
        itm = QTableWidgetItem("Network")
        self.ui.tblStatus.setItem(0,0,itm)

        itm = QTableWidgetItem("Dongle")
        self.ui.tblStatus.setItem(1,0,itm)

        itm = QTableWidgetItem("Pump")
        self.ui.tblStatus.setItem(2,0,itm)

        itm = QTableWidgetItem("Purger")
        self.ui.tblStatus.setItem(3,0,itm)


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