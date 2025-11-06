#!/bin/bash
# ==========================================================
# Script: clean_builds.sh
# Descripción: Limpia builds antiguos y temporales del entorno Godot.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
BUILD_PATH="$HOME/RealmQuest_Engine_4_5_1/builds"

echo "🧹 Eliminando builds antiguos..."
find "$BUILD_PATH" -type f -name "*.tmp" -delete
find "$BUILD_PATH" -type d -name "old_*" -exec rm -rf {} +

echo "✅ Builds limpios y entorno optimizado."

