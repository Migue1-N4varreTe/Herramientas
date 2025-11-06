#!/bin/bash
# ────────────────────────────────────────────────
# 💾 Command Core v4.2 – Restore Backup
# Restaura el backup más reciente desde ~/backups/

BACKUP_DIR="$HOME/backups"
LATEST_BACKUP=$(ls -t $BACKUP_DIR/*.tar.gz 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
  echo "⚠️ No backup found."
  exit 1
fi

echo "🔄 Restoring from $LATEST_BACKUP..."
tar -xzf "$LATEST_BACKUP" -C "$HOME"
echo "✅ Restore completed."
