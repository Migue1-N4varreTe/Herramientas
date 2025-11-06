#!/bin/bash
# ==========================================================
# Script: trace_session.sh
# Descripción: Rastrea sesiones activas y consumo de recursos.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
echo "📡 Sesiones activas:"
who
echo
echo "⚙️ Procesos más intensivos:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 10
echo "✅ Sesión trazada con éxito."

