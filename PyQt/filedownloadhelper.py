import time
import threading
from ftplib import FTP

import PyQt5
from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *

class FileDownloadHelper(QtCore.QThread):
    blocktransferred = pyqtSignal()

    def __init__(self,server,directory,filename):
        super().__init__()
        print("Server " , server)
        print("Directory " , directory)
        print("File ", filename)
        self._server = server
        self._directory = directory
        self._filename = filename
        print("Creating a thread")

    @staticmethod
    def BlockTransferred(blk):
        print("Block transferred" )
        self.blocktransferred.emit()

    def GetFile(self):
        ftp=FTP(self._server)
        ftp.login()
        ftp.cwd(self._directory)
        ftp.retrbinary("RETR %s" % self._filename , self.BlockTransferred , 1000 )
        self.binfile.close()
        ftp.quit()

    def run(self):
        print("Running")
        self.GetFile()
