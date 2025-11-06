#!/bin/bash
# ==========================================================
# Script: upload_telemetry.sh
# Descripción: Envía métricas a un servidor remoto o API de análisis.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
SERVER_URL="https://telemetry.commandcore.local/api/upload"
DATA_FILE="/tmp/metrics.json"

echo "📤 Generando paquete de telemetría..."
echo '{"version":"4.2","timestamp":"'"$(date)"'"}' > "$DATA_FILE"

echo "🌍 Subiendo datos..."
curl -s -X POST -H "Content-Type: application/json" -d @"$DATA_FILE" "$SERVER_URL" \
  && echo "✅ Telemetría enviada correctamente." \
  || echo "⚠️ Error al enviar telemetría."

