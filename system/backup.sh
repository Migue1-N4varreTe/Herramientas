#!/usr/bin/env bash
# ============================================================
# 💾 backup.sh — Sistema de respaldo Ricitos
# ============================================================

BACKUP_DIR="$HOME/Ricitos_Backups"
TARGETS=("$HOME/scripts" "$HOME/ricitos_system_logs")
mkdir -p "$BACKUP_DIR"
STAMP=$(date +"%Y-%m-%d_%H-%M-%S")

if [[ "$1" == "--restore" ]]; then
  echo "🔄 Restaurar backup:"
  select FILE in "$BACKUP_DIR"/*.tar.gz; do
    [ -z "$FILE" ] && exit
    tar -xzf "$FILE" -C "$HOME"
    echo "✅ Backup restaurado desde $FILE"
    exit 0
  done
else
  FILE="$BACKUP_DIR/ricitos_backup_$STAMP.tar.gz"
  tar -czf "$FILE" "${TARGETS[@]}"
  echo "✅ Backup creado: $FILE"
fi

