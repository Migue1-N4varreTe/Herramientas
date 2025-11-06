#!/bin/bash
# ────────────────────────────────────────────────
# 🧰 Command Core v4.2 – Staging Environment Setup
# Crea entorno temporal de pruebas y compila proyecto.

STAGING_DIR="./staging"
mkdir -p "$STAGING_DIR"
echo "🚧 Setting up staging environment..."
rsync -av --exclude 'staging/' ./ "$STAGING_DIR/"
cd "$STAGING_DIR" && bash ../compile.sh
bash ../health_check.sh
echo "✅ Staging environment ready."
