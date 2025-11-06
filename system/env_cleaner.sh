#!/usr/bin/env bash
# ============================================================
# 🧹 env_cleaner.sh — Limpiador de entorno Ricitos
# ============================================================

TARGETS=(
  "$HOME/.local/share/godot/mono/temp"
  "$HOME/RealmQuest_Engine_4_5_1/.import"
  "$HOME/RealmQuest_Engine_4_5_1/bin"
  "$HOME/RealmQuest_Engine_4_5_1/obj"
)

echo "🧹 Iniciando limpieza..."
for t in "${TARGETS[@]}"; do
  if [ -d "$t" ]; then
    du -sh "$t"
    rm -rf "$t"
    echo "✅ Limpio: $t"
  fi
done
echo "✨ Limpieza completada."

