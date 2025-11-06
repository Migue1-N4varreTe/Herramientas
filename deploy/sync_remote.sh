#!/bin/bash
# ==========================================================
# Script: sync_remote.sh
# Descripción: Sincroniza repositorios y copias de seguridad remotas.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
REMOTE_DIR="/mnt/remote_sync"
LOCAL_DIR="$HOME/Projects"

echo "🌐 Iniciando sincronización remota..."
rsync -av --progress "$LOCAL_DIR" "$REMOTE_DIR" || {
  echo "❌ Error al sincronizar con remoto."
  exit 1
}

echo "✅ Sincronización completada correctamente."

