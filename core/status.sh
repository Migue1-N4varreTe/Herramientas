#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: status.sh
# Descripción: Resumen rápido del sistema: CPU, RAM, disco, red y uptime.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail

LOG_DIR="/home/sandbox/command_core_logs"
mkdir -p "$LOG_DIR"

timestamp() { date '+%F %T'; }

echo "🔎 Estado rápido del sistema - $(timestamp)" | tee -a "$LOG_DIR/status.log"
echo "Hostname: $(hostname)" | tee -a "$LOG_DIR/status.log"
echo "Uptime: $(uptime -p)" | tee -a "$LOG_DIR/status.log"
echo "Kernel: $(uname -r)" | tee -a "$LOG_DIR/status.log"
echo "CPU: $(lscpu | awk -F: '/Model name/{print $2}' | xargs)" | tee -a "$LOG_DIR/status.log"
echo "Load: $(cut -d ' ' -f1-3 /proc/loadavg)" | tee -a "$LOG_DIR/status.log"
echo "Memory: $(free -h | awk '/Mem:/ {print $3"/"$2}')" | tee -a "$LOG_DIR/status.log"
echo "Disk root: $(df -h / | tail -1 | awk '{print $3" used of "$2" ("$5")"}')" | tee -a "$LOG_DIR/status.log"
echo "Interfaces de red (act):" | tee -a "$LOG_DIR/status.log"
ip -4 addr show scope global | awk '/inet /{print $2" - "$NF}' | tee -a "$LOG_DIR/status.log"

echo "" | tee -a "$LOG_DIR/status.log"
echo "✅ Resumen guardado en $LOG_DIR/status.log"
