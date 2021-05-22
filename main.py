# This Python file uses the following encoding: utf-8
import sys
import os

from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtCore import QFile
from PyQt5 import uic


class StoreWindow(QMainWindow):
    def __init__(self):
        super(StoreWindow, self).__init__()
        self.load_ui()

    def load_ui(self):
        path = os.path.join(os.path.dirname(__file__), "form.ui")
        ui_file = QFile(path)
        ui_file.open(QFile.ReadOnly)
        uic.loadUi(ui_file, self)
        ui_file.close()


if __name__ == "__main__":
    app = QApplication([])
    widget = StoreWindow()
    widget.show()
    sys.exit(app.exec_())
