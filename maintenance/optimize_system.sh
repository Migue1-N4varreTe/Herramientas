#!/bin/bash
# ==========================================================
# Script: optimize_system.sh
# Descripción: Limpieza profunda del sistema: cache, paquetes huérfanos, y espacio en disco.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
echo "🧼 Iniciando optimización del sistema..."

sudo apt autoremove -y
sudo apt clean
sudo journalctl --vacuum-time=7d

echo "✅ Optimización completada con éxito."

