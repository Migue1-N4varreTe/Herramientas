#!/bin/bash
# ────────────────────────────────────────────────
# 🚀 Command Core v4.2 – Render Deployment
# Despliegue automatizado a Render

LOG_FILE="$HOME/command-core/logs/deploy_render.txt"
echo "🌐 Connecting to Render..."
git push render main | tee "$LOG_FILE"
echo "✅ Render deployment completed."
