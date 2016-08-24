import time
import PyQt5
from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtNetwork import QNetworkAccessManager, QNetworkRequest

from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QTableWidgetItem,
                             QDialog)
from PyQt5 import uic
import filedownloadhelper

class FileTransfer(QDialog):
    def __init__(self):
        super().__init__()
        self.ui = uic.loadUi("filetransfer.ui")

        self.ui.btnTransfer.clicked.connect(self.TransferClicked)
        self.ui.btnCancel.clicked.connect(self.CancelClicked)

        self.ui.show()
        self.netmanager=QNetworkAccessManager()
        self.url=QUrl("ftp://ftp.gnu.org")
        self.netreq=self.netmanager.get(QNetworkRequest(self.url))


    @pyqtSlot()
    def TransferClicked(self):
        print("Transfer clicked" )
        helper = filedownloadhelper.FileDownloadHelper(self.ui.txtSiteName.text(),self.ui.txtDirName.text(),self.ui.txtFileName.text())
        try:
            helper.start()
        except:
            print("Exception starting the thread")
            raise
        print("Started the helper thread")
        # self.ui.done(1)
        time.sleep(10)
    @pyqtSlot()
    def CancelClicked(self):
        print("Cancel clicked" )
        self.ui.done(0)