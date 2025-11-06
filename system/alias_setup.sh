#!/usr/bin/env bash
# ============================================================
# 🔗 alias_setup.sh — Registro de alias Ricitos
# ============================================================

ALIASES=(
  "checkpro='bash ~/scripts/Check.sh'"
  "compilepro='bash ~/scripts/Compile.sh'"
  "repairpro='bash ~/scripts/repair.sh'"
  "monopro='bash ~/scripts/mono.sh'"
  "apppro='bash ~/scripts/App.sh'"
  "controlpro='bash ~/scripts/control_center.sh'"
)

for alias_cmd in "${ALIASES[@]}"; do
  if ! grep -q "$alias_cmd" ~/.bashrc; then
    echo "alias $alias_cmd" >> ~/.bashrc
    echo "✅ Alias agregado: $alias_cmd"
  else
    echo "🔁 Alias ya presente: $alias_cmd"
  fi
done

source ~/.bashrc
echo "🎯 Aliases activados. Usa 'controlpro' para iniciar el panel."

