#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: telemetry_cleanup.sh
# Descripción: Limpia logs antiguos y compresión de reportes ( > N días )
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail
LOG_DIR="/home/sandbox/command_core_logs"
DAYS="${1:-30}"
mkdir -p "$LOG_DIR"

echo "🧹 Limpiando logs con más de $DAYS dias en $LOG_DIR"
find "$LOG_DIR" -type f -mtime +$DAYS -print -exec gzip -9 {} \; || true
echo "✅ Telemetry cleanup finalizado."
