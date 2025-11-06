#!/bin/bash
# ────────────────────────────────────────────────
# 📊 Command Core v4.2 – Metrics Report
# Consolida métricas del sistema y genera reportes .csv

LOG_DIR="$HOME/command-core/logs"
REPORT="$LOG_DIR/metrics_$(date +%Y%m%d).csv"

echo "timestamp,script,execution_time,status" > "$REPORT"
grep -r "Execution time" "$LOG_DIR" | sed 's/ /,/g' >> "$REPORT"
echo "✅ Metrics exported to $REPORT"
