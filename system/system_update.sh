#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: system_update.sh
# Descripción: Actualiza el sistema (apt, snap, flatpak) y limpia caches.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail
LOG_DIR="/home/sandbox/command_core_logs"
mkdir -p "$LOG_DIR"
echo "📦 Iniciando actualización del sistema - $(date)" | tee -a "$LOG_DIR/system_update.log"

sudo apt update -y && sudo apt upgrade -y || echo "⚠️ apt update/upgrade falló" | tee -a "$LOG_DIR/system_update.log"
if command -v snap >/dev/null 2>&1; then sudo snap refresh || echo "⚠️ snap refresh fallo" | tee -a "$LOG_DIR/system_update.log"; fi
if command -v flatpak >/dev/null 2>&1; then flatpak update -y || echo "⚠️ flatpak update fallo" | tee -a "$LOG_DIR/system_update.log"; fi

# Limpiezas
sudo apt autoremove -y || true
sudo apt autoclean -y || true
echo "✅ Actualización finalizada. Ver $LOG_DIR/system_update.log" | tee -a "$LOG_DIR/system_update.log"
