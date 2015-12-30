from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtNetwork import *

from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QDialog,
                             QStyle )
from PyQt5 import uic

class ConsoleIP(QDialog):
    def __init__(self):
        super().__init__()
        ipadrrexp = QRegExp("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")
        ipadrvalidator = QRegExpValidator(ipadrrexp)
        self.counter=0
        self.ui = uic.loadUi("startup.ui")
        self.ui.txtConsoleIPAddress.setValidator(ipadrvalidator)

        self.ui.btnCancel.clicked.connect(self.CancelClicked)
        self.ui.btnConnect.clicked.connect(self.ConnectClicked)

        self.timer = QTimer()
        self.ui.pbTransferFiles.setValue(0)
        self.ui.pbTransferFiles.hide()

        self.timer.timeout.connect(self.TimerTicks)
        self.ui.show()

    @pyqtSlot()
    def CancelClicked(self):
        self.ui.done(0)

    @pyqtSlot()
    def ConnectClicked(self):
        if self.counter > 0:
            self.ui.done(1)
        else:
            self.ui.pbTransferFiles.show()
            self.ui.lblInstruction.setText("Please wait for file Uploads")
            self.ui.btnConnect.setEnabled(False)
            self.timer.start(100)

    @pyqtSlot()
    def TimerTicks(self):
        self.counter += 10
        if self.counter > 100:
            self.ui.btnConnect.setText("Proceed")
            self.ui.btnConnect.setEnabled(1)
        else:
            self.ui.pbTransferFiles.setValue(self.counter)
