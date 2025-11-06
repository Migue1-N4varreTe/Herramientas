#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: log_rotate.sh
# Descripción: Rota y comprime logs antiguos del command core y proyectos.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail
LOG_DIR="/home/sandbox/command_core_logs"
DAYS_KEEP="${1:-30}"
mkdir -p "$LOG_DIR"

echo "Rotando logs older than $DAYS_KEEP days in $LOG_DIR"
find "$LOG_DIR" -type f -mtime +$DAYS_KEEP -print -exec gzip -9 {} \; || true
echo "✅ Rotación completada."
