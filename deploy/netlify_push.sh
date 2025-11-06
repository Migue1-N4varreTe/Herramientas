#!/bin/bash
# ────────────────────────────────────────────────
# ☁️ Command Core v4.2 – Netlify Deployment
# Despliegue automático a Netlify

BUILD_DIR="./dist"
LOG_FILE="$HOME/command-core/logs/deploy_netlify.txt"

if ! command -v netlify &>/dev/null; then
  echo "⚠️ Netlify CLI not found. Install with: npm install -g netlify-cli"
  exit 1
fi

echo "🚀 Deploying to Netlify..."
netlify deploy --dir="$BUILD_DIR" --prod | tee "$LOG_FILE"
