#!/usr/bin/env python
from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QDialog)

import filetransfer


if __name__ == '__main__':
    import sys

    app = QApplication(sys.argv)
    dlg = filetransfer.FileTransfer()
    app.exec_()
    stat=dlg.ui.result()
    sys.exit(stat)

