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

class SwInstall(QDialog):
    def __init__(self):
        super().__init__()
        self.ui = uic.loadUi("swinstall.ui")
        self.ui.tblInstallStatus.setColumnCount(6)
        self.ui.tblInstallStatus.setRowCount(4)

        hdritm = QTableWidgetItem("Device")
        self.ui.tblInstallStatus.setHorizontalHeaderItem(0,hdritm)

        hdritm = QTableWidgetItem("To Install")
        self.ui.tblInstallStatus.setHorizontalHeaderItem(1,hdritm)

        hdritm = QTableWidgetItem("HW Version")
        self.ui.tblInstallStatus.setHorizontalHeaderItem(2,hdritm)

        hdritm = QTableWidgetItem("SW Version")
        self.ui.tblInstallStatus.setHorizontalHeaderItem(3,hdritm)

        hdritm = QTableWidgetItem("Option")
        self.ui.tblInstallStatus.setHorizontalHeaderItem(4,hdritm)

        hdritm = QTableWidgetItem("Progress")
        self.ui.tblInstallStatus.setHorizontalHeaderItem(5,hdritm)

        idx=0
        for dev in ["EPC","AHP","EPM","PBM1","PBM2","KBD","PMD"]:
            itm = QTableWidgetItem(dev)
            self.ui.tblInstallStatus.setRowCount(idx+1)
            self.ui.tblInstallStatus.setItem(idx,0,itm)
            idx += 1

        self.timer=QTimer()
        self.timer.timeout.connect(self.TimerFired)
        self.timer.start(1000)
        self.counter = 0

        self.ui.btnCancel.clicked.connect(self.CancelClicked)
        self.ui.btnExit.clicked.connect(self.ExitClicked)
        self.ui.show()

    @pyqtSlot()
    def TimerFired(self):
        self.ui.lcdNumber.display( self.counter )
        self.counter += 1

    @pyqtSlot()
    def CancelClicked(self):
        self.ui.done(0)
        self.timer.stop()

    @pyqtSlot()
    def ExitClicked(self):
        self.timer.stop()
        print("Proceed")
        self.ui.done(1)