#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3
# ------------------------------------------------------------
# Script: syscheck.sh
# Descripción: Verificación avanzada de dependencias, servicios y estado del sistema.
# Versión: 4.3
# Autor: Command Core System
# Fecha: 2025-11-05
# ============================================================

set -euo pipefail

LOG_DIR="/home/sandbox/command_core_logs"
mkdir -p "$LOG_DIR"
OUT="$LOG_DIR/syscheck_$(date +%F_%H-%M-%S).log"

echo "🧾 Syscheck - $(date)" > "$OUT"

# Dependencias críticas
deps=(git curl rsync awk sed ip netcat lscpu smartctl)
echo "🔹 Dependencias:" >> "$OUT"
for d in "${deps[@]}"; do
  if command -v "$d" >/dev/null 2>&1; then
    echo "  ✅ $d: $(command -v $d 2>/dev/null)" >> "$OUT"
  else
    echo "  ⚠️  $d: MISSING" >> "$OUT"
  fi
done

# Espacio en disco
echo "" >> "$OUT"
echo "🔹 Espacio en disco (root):" >> "$OUT"
df -h / >> "$OUT"

# Inodos
echo "" >> "$OUT"
echo "🔹 Inodos (root):" >> "$OUT"
df -i / >> "$OUT"

# Versiones de runtime
echo "" >> "$OUT"
echo "🔹 Runtimes:" >> "$OUT"
node -v 2>/dev/null || echo "  node: N/D" >> "$OUT"
pnpm -v 2>/dev/null || echo "  pnpm: N/D" >> "$OUT"
dotnet --version 2>/dev/null || echo "  dotnet: N/D" >> "$OUT"
godot4 --version 2>/dev/null || echo "  godot4: N/D" >> "$OUT"

# Servicios systemd (check common)
echo "" >> "$OUT"
echo "🔹 Servicios systemd (status breve):" >> "$OUT"
for s in ssh docker cron; do
  if systemctl list-units --type=service --all | grep -q "$s.service"; then
    systemctl is-active --quiet "$s.service" && echo "  ✅ $s running" >> "$OUT" || echo "  ⚠️  $s not running" >> "$OUT"
  else
    echo "  ℹ️ $s not installed" >> "$OUT"
  fi
done

echo "" >> "$OUT"
echo "✅ Syscheck completo - reporte: $OUT"
echo "$OUT"
