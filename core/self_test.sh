#!/bin/bash
# ==========================================================
# Script: self_test.sh
# Descripción: Ejecuta pruebas internas de los módulos del Command Core.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
ROOT_DIR="$(dirname "$(realpath "$0")")/.."

echo "🧪 Ejecutando pruebas internas del Command Core..."

for module in core deploy godot maintenance system telemetry; do
  if [ -d "$ROOT_DIR/$module" ]; then
    echo "🔍 Verificando módulo: $module"
    find "$ROOT_DIR/$module" -type f -name "*.sh" -exec bash -n {} \; || {
      echo "❌ Error de sintaxis en módulo $module"
      exit 1
    }
  fi
done

echo "✅ Todas las pruebas internas completadas sin errores."

