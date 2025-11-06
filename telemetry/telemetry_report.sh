#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: telemetry_report.sh
# Descripción: Genera un reporte resumen de telemetría (logs, builds, deploys) en formato legible.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail
LOG_DIR="/home/sandbox/command_core_logs"
REPORT="/home/sandbox/command_core_logs/telemetry_report_$(date +%F_%H-%M).txt"
mkdir -p "/home/sandbox/command_core_logs"

echo "Telemetry Report - $(date)" > "$REPORT"
echo "" >> "$REPORT"
echo "Últimos archivos de log:" >> "$REPORT"
ls -1 "$LOG_DIR"/*.log 2>/dev/null | tail -n 10 >> "$REPORT" || true

echo "" >> "$REPORT"
echo "Resumen (errores frecuentes):" >> "$REPORT"
grep -RihE "error|failed|exception|panic" "$LOG_DIR" 2>/dev/null | sed -n '1,200p' >> "$REPORT" || true

echo "" >> "$REPORT"
echo "Resumen de builds (estimado):" >> "$REPORT"
grep -Rih "Build completado|Build OK|Compile" "$LOG_DIR" 2>/dev/null | wc -l >> "$REPORT" || true

echo "✅ Reporte generado: $REPORT"
echo "$REPORT"
