#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: check_disk.sh
# Descripción: Analiza particiones, uso, inodos y reporta errores SMART si existe disco físico.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail
LOG_DIR="/home/sandbox/command_core_logs"
OUT="$LOG_DIR/disk_check_$(date +%F_%H-%M-%S).txt"
mkdir -p "$LOG_DIR"

echo "Disk Check - $(date)" > "$OUT"
df -h >> "$OUT"
df -i >> "$OUT"

# intentamos SMART si smartctl existe
if command -v smartctl >/dev/null 2>&1; then
  for disk in /dev/sd?; do
    echo "SMART: $disk" >> "$OUT"
    sudo smartctl -H "$disk" >> "$OUT" 2>&1 || true
  done
else
  echo "smartctl no disponible - no se ejecutó SMART" >> "$OUT"
fi

echo "✅ Disk check completado. Reporte: $OUT"
echo "$OUT"
