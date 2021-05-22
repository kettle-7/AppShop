# This Python file uses the following encoding: utf-8
import sys
import os

from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget
from PyQt5.QtCore import QFile
from PyQt5 import uic, QtGui


class StoreWindow(QMainWindow):
    def __init__(self):
        super(StoreWindow, self).__init__()
        self.load_ui()

    def load_ui(self):
        path = os.path.join(os.path.dirname(__file__), "form.ui")
        ui_file = QFile(path)
        ui_file.open(QFile.ReadOnly)
        self.ui = uic.loadUi(ui_file, self)
        self.about=NonClose()
        uic.loadUi(os.path.join(os.path.dirname(__file__), "about.ui"), self.about)
        self.ui.A_About.triggered.connect(self.about.show)
        ui_file.close()


class NonClose(QWidget):
    def __init__(self, *args, **kwargs):
        super(NonClose, self).__init__(*args, **kwargs)

    def closeEvent(self, e: QtGui.QCloseEvent) -> None:
        self.hide()


if __name__ == "__main__":
    app = QApplication([])
    widget = StoreWindow()
    widget.show()
    sys.exit(app.exec_())
