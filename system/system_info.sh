#!/bin/bash
# ==========================================================
# Script: system_info.sh
# Descripción: Muestra información del sistema y del núcleo Command Core.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
echo "💡 Información del Sistema"
echo "--------------------------"
echo "Kernel: $(uname -r)"
echo "SO: $(lsb_release -ds 2>/dev/null || echo 'No disponible')"
echo "CPU: $(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
echo "RAM: $(free -h | awk '/Mem:/ {print $2}')"
echo "Command Core Version: 4.2"
echo "Fecha: $(date)"
echo "✅ Reporte completado."

