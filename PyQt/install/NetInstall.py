#!/usr/bin/env python
from PyQt5 import QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import (QWidget,
                             QToolTip,
                             QPushButton,
                             QApplication,
                             QDialog)
import startup
import status

if __name__ == '__main__':
    import sys

    app = QApplication(sys.argv)
    while True:
        w = startup.ConsoleIP()
        app.exec_()
        stat = w.ui.result()
        if stat == 1:
            w = status.ConnectionStatus()
            app.exec_()
            stat = w.ui.result()
            if stat == 1:
                print("Proceeding")
                break
        else:
            break

    sys.exit(stat)