#!/bin/bash
# ────────────────────────────────────────────────
# 🧠 Command Core v4.2 – Log Analyzer
# Analiza logs para encontrar errores y anomalías.

LOG_DIR="$HOME/command-core/logs"
echo "📂 Analyzing logs in $LOG_DIR..."

grep -riE "error|failed|exception" "$LOG_DIR" > "$LOG_DIR/anomaly_report.txt" || true
echo "✅ Analysis complete. Report: $LOG_DIR/anomaly_report.txt"
