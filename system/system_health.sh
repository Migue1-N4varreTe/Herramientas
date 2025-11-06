#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: system_health.sh
# Descripción: Monitor básico de servicios y estado. Opción GUI con Zenity.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail
LOG_DIR="/home/sandbox/command_core_logs"
mkdir -p "$LOG_DIR"

mode="${1:-cli}"

if [[ "$mode" == "gui" ]]; then
  if command -v zenity >/dev/null 2>&1; then
    summary=$(bash -c "uptime -p; echo; free -h | awk '/Mem:/ {print $3"/"$2}'; echo; df -h / | tail -1")
    echo "$summary" | zenity --text-info --title="System Health" --width=640 --height=360 || true
    exit 0
  else
    echo "⚠️ Zenity no disponible, ejecutando en CLI."
  fi
fi

echo "System Health - $(date)" | tee -a "$LOG_DIR/system_health.log"
echo "Uptime: $(uptime -p)" | tee -a "$LOG_DIR/system_health.log"
free -h | tee -a "$LOG_DIR/system_health.log"
df -h / | tee -a "$LOG_DIR/system_health.log"
echo "✅ Reporte generado en $LOG_DIR/system_health.log"
