#!/usr/bin/env python3
import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QTextEdit

THEME = sys.argv[1] if len(sys.argv) > 1 else "neon"

app = QApplication(sys.argv)
window = QWidget()
window.setWindowTitle(f"Command Core GUI v4.3 [{THEME}]")

layout = QVBoxLayout()
txt = QTextEdit()
txt.setReadOnly(True)
txt.append("🔮 Command Core GUI\n")
txt.append(f"Tema seleccionado: {THEME}\n")

# Botones de acciones principales
btn_status = QPushButton("Status")
btn_syscheck = QPushButton("Syscheck")
btn_metrics = QPushButton("Metrics")
btn_deploy = QPushButton("Deploy")
btn_exit = QPushButton("Salir")

layout.addWidget(txt)
layout.addWidget(btn_status)
layout.addWidget(btn_syscheck)
layout.addWidget(btn_metrics)
layout.addWidget(btn_deploy)
layout.addWidget(btn_exit)

def log(msg):
    txt.append(msg)

btn_status.clicked.connect(lambda: log("Ejecutando status..."))
btn_syscheck.clicked.connect(lambda: log("Ejecutando syscheck..."))
btn_metrics.clicked.connect(lambda: log("Ejecutando metrics..."))
btn_deploy.clicked.connect(lambda: log("Ejecutando deploy..."))
btn_exit.clicked.connect(lambda: sys.exit(0))

window.setLayout(layout)
window.resize(600, 400)
window.show()
sys.exit(app.exec_())

