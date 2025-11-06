#!/bin/bash
# ==========================================================
# Script: auto_update.sh
# Descripción: Actualiza automáticamente todos los módulos del Command Core desde su repositorio remoto.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
ROOT_DIR="$(dirname "$(realpath "$0")")/.."

echo "🔁 Iniciando auto-actualización del Command Core..."

# Verifica que el repositorio esté inicializado
if [ ! -d "$ROOT_DIR/.git" ]; then
  echo "⚠️ No se detectó repositorio Git. Inicializando..."
  git -C "$ROOT_DIR" init
  git -C "$ROOT_DIR" remote add origin git@github.com:usuario/command-core-v4.2.git 2>/dev/null || true
fi

# Guarda cambios locales antes de actualizar
git -C "$ROOT_DIR" add .
git -C "$ROOT_DIR" commit -m "🔒 Auto-commit previo a actualización" || true

# Obtiene últimas actualizaciones
echo "📡 Sincronizando con repositorio remoto..."
git -C "$ROOT_DIR" pull origin main --rebase || {
  echo "⚠️ No se pudo sincronizar. Revisa conexión o credenciales."
  exit 1
}

# Actualiza permisos de ejecución
find "$ROOT_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo "✅ Actualización completada. Todos los módulos están al día."

