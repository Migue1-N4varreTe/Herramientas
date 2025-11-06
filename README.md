# 🔮 Command Core (CC) v4.3 — Núcleo Unificado

**Autor:** Migue1-N4varreTe  
**Fecha de actualización:** 2025-11-05  

Command Core (CC) es un orquestador unificado para gestión de proyectos, automatización de builds, deploys, backups, telemetría y mantenimiento del sistema.

---

## 🔹 Características principales

- Gestión de proyectos en modo local o global.
- GUI segura (`gui-safe`) con soporte de temas neon y dark.
- Fallback TUI para entornos sin display.
- Integración de todos los módulos (`build`, `dev`, `deploy`, `backup`, `telemetry`, `repair`, `optimize`).
- Registro de logs y reportes visuales en `~/command_core_logs`.
- Backups automáticos en `~/CommandCore_Backups`.
- Comandos internos y wrappers para scripts externos, con fallback seguro.

---

## 📁 Estructura de directorios

CC/
├── CC.sh
├── core/
├── deploy/
├── godot/
├── gui/
├── maintenance/
├── system/
└── telemetry/

---

## ⚡ Instalación

```bash
git clone git@github.com:Migue1-N4varreTe/Herramientas.git CC
cd CC
find ~/CC -type f -name "*.sh" -exec chmod +x {} \;
chmod +x CC.sh
export PATH="$HOME/CC:$PATH"
Asegúrate de tener Python 3 y un entorno gráfico si quieres usar la GUI.

🚀 Comandos principales
bash
Copiar código
./CC.sh <comando> [subcomando|opciones]
Core
init <perfil> – Inicializa un proyecto.

build [rebuild|diagnose] – Compila el proyecto.

dev – Arranca entorno de desarrollo.

deploy – Despliega proyecto.

update [all] – Actualiza CC o proyectos.

update-core – Actualiza solo el núcleo CC.

Maintenance
repair [gui] – Repara sistema o GUI.

maintain [normal|deep|gui] – Optimización y limpieza.

system-repair – Reparación avanzada.

optimize – Optimiza almacenamiento y sistema.

Backup
auto-backup – Crea backup automático.

backup restore <archivo> – Restaura backup.

Deploy / Sync
deploy-sync – Sincroniza repositorios.

staging – Prepara staging.

netlify – Push a Netlify.

render – Push a Render.

Telemetry & Metrics
metrics [gui] – Métricas rápidas.

telemetry-report – Genera reporte de telemetría.

telemetry-scan – Escanea telemetría.

telemetry-clean – Limpia logs y telemetría antiguos.

System
status – Estado rápido del sistema.

syscheck – Verifica dependencias.

system-update – Actualiza sistema operativo.

system-health – Revisa salud general.

check-disk – Verifica discos y SMART.

rotate-logs – Comprime logs antiguos.

system-info – Información detallada del sistema.

user-audit – Auditoría de usuarios.

export – Exporta proyectos y CC completo.

Other
gui – Lanza GUI interactiva.

gui-safe [dark|neon] – Lanza GUI segura con tema opcional.

notify <msg> – Envía notificación del sistema.

help – Muestra ayuda.

🖥️ Uso de GUI segura
bash                                                                         
Copiar código
./CC.sh gui-safe neon   # Neon theme
./CC.sh gui-safe dark   # Dark theme
Si no hay entorno gráfico, se lanza automáticamente el TUI (CLI friendly).

📄 Logs y backups
Logs: ~/command_core_logs

Reportes visuales: ~/command_core_logs/visual_reports

Backups: ~/CommandCore_Backups

⚠️ Recomendaciones
Ejecutar ./CC.sh system-update periódicamente.

Revisar métricas con ./CC.sh metrics gui.

Mantener Python 3 actualizado si se usa la GUI.

🛠️ Notas de la versión v4.3
GUI segura (gui-safe) implementada con fallback TUI.

Soporte de temas neon y dark.

Integración completa de todos los comandos CC desde GUI y CLI.

Corrección de errores en wrappers de scripts y módulos internos.

MLM ASSOCIATE  |  LEARN LAB STUDIO 
  <3~<3~<3 i Love P.K. <3~<3~<3 
