# 🔮 Command Core (CC) v4.3

**Command Core** es el núcleo de automatización y orquestación para tus proyectos de desarrollo, deployments, mantenimiento y telemetría, todo unificado en un solo script con GUI/TUI y módulos integrados.

---

## 🌟 Features principales

- **Core & Build:** Inicialización de proyectos, compilación, desarrollo y despliegue.
- **Mantenimiento:** Reparación automática, optimización de sistema y limpieza de logs.
- **Backups & Restore:** Backups rápidos de proyectos y restauración segura.
- **Telemetry & Metrics:** Escaneo de logs, métricas estimadas de builds/deploys y reportes visuales.
- **GUI/TUI:** Interfaz gráfica “Ricitos Neon” elegante y fallback TUI para terminales.
- **System Utilities:** Verificación de dependencias, chequeo de hardware y actualización del sistema.
- **Integración modular:** Scripts externos y fallback internos, con prioridad a implementaciones locales.

---

## 🖌 Branding “Ricitos Neon”

- **Tema oscuro elegante**
- Colores eléctricos azul/cian
- Bordes suaves y tipografía **Fira Code**
- Diseño GUI interactivo con TUI fallback

---

## ⚡ Instalación

```bash
# Clonar repositorio
git clone git@github.com:Migue1-N4varreTe/Herramientas.git ~/scripts

# Dar permisos de ejecución
chmod -R +x ~/scripts

# Ejecutar núcleo
~/scripts/CC.sh help

# Ver ayuda
CC.sh help

# Estado del sistema
CC.sh status

# Comprobación de dependencias
CC.sh syscheck

# Modo GUI
CC.sh gui

# Backup automático
CC.sh auto-backup

# Deploy y sincronización
CC.sh deploy
CC.sh deploy-sync

# Actualización del núcleo
CC.sh update-core

scripts/
├── core/
├── deploy/
├── maintenance/
├── godot/
├── system/
├── telemetry/
├── system/gui/cc_dashboard.py
└── CC.sh

🛠 Requisitos

Bash 5+

Python3 (para GUI)

Git, rsync, curl, dotnet, Node.js, pnpm, Godot 4 (opcional)

Linux (probado en Zorin, Ubuntu)

💡 Notas

GUI requiere entorno gráfico (DISPLAY).

Si no hay GUI disponible, cae automáticamente en TUI.

Logs y reportes se generan en: ~/command_core_logs/ y backups en ~/CommandCore_Backups/.

Integración continua: módulos externos pueden colocarse en ~/scripts/<module>/ y el core los prioriza.

🔗 Contribuciones

Puedes contribuir creando módulos nuevos, optimizando scripts o proponiendo mejoras de GUI/TUI.

📜 Licencia

CC v4.3 — Uso personal y educativo. Para uso comercial, contacta al autor.

MLM ASSOCIATE / LEARN LAB STUDIO 

 <3 <3  i Love P.k. <3 <3 
