#!/usr/bin/env bash
# ============================================================
# 🚀 deploy.sh — Despliegue rápido de RealmQuest Engine
# ============================================================

PROJECT_DIR="$HOME/RealmQuest_Engine_4_5_1"
EXPORT_DIR="$HOME/RealmQuest_Exports"
mkdir -p "$EXPORT_DIR"

echo "⚙️ Empaquetando RealmQuest..."
tar -czf "$EXPORT_DIR/RealmQuest_$(date +%Y-%m-%d_%H-%M-%S).tar.gz" "$PROJECT_DIR"

echo "✅ Despliegue completado. Archivos exportados a:"
echo "$EXPORT_DIR"

