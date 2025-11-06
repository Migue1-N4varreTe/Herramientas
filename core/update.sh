#!/usr/bin/env bash
# ============================================================
# ♻️ update.sh — Actualizador de scripts Ricitos
# ------------------------------------------------------------
# Actualiza todos los scripts desde un repo Git o carpeta local.
# ============================================================

REPO_URL="git@github.com:Migue1-N4varreTe/RicitosSystemPro.git"
SCRIPTS_DIR="$HOME/scripts"
cd "$SCRIPTS_DIR" || exit

if [ -d .git ]; then
  git fetch origin && git pull origin main
else
  echo "⚙️ Clonando scripts desde $REPO_URL..."
  git clone "$REPO_URL" "$SCRIPTS_DIR"
fi

chmod +x "$SCRIPTS_DIR"/*.sh
echo "✅ Scripts actualizados."

