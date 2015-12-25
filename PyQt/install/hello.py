
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
