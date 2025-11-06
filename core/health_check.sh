#!/bin/bash
# ==========================================================
# Script: health_check.sh
# Descripción: Verifica la integridad, permisos y dependencias del Command Core.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
ROOT_DIR="$(dirname "$(realpath "$0")")/.."
LOG_FILE="$ROOT_DIR/logs/health_report_$(date +%F_%H-%M-%S).log"

mkdir -p "$ROOT_DIR/logs"
echo "🩺 Iniciando verificación de integridad del sistema..." | tee "$LOG_FILE"

# 1. Verifica permisos de ejecución
echo "🔹 Verificando permisos de scripts..." | tee -a "$LOG_FILE"
find "$ROOT_DIR" -type f -name "*.sh" ! -perm -111 -print -exec chmod +x {} \; >>"$LOG_FILE" 2>&1

# 2. Verifica dependencias básicas
echo "🔹 Comprobando dependencias principales..." | tee -a "$LOG_FILE"
DEPENDENCIAS=(git curl rsync awk)
for dep in "${DEPENDENCIAS[@]}"; do
  if ! command -v "$dep" &>/dev/null; then
    echo "❌ Falta dependencia: $dep" | tee -a "$LOG_FILE"
  else
    echo "✅ $dep presente" | tee -a "$LOG_FILE"
  fi
done

# 3. Chequea conectividad de red
echo "🌐 Probando conectividad a Internet..." | tee -a "$LOG_FILE"
ping -c 1 github.com &>/dev/null && echo "✅ Conectividad OK" | tee -a "$LOG_FILE" || echo "⚠️ Sin conexión" | tee -a "$LOG_FILE"

# 4. Genera resumen final
echo -e "\n🧾 Resumen:" | tee -a "$LOG_FILE"
grep -E "❌|⚠️" "$LOG_FILE" || echo "✅ Sistema íntegro, sin problemas detectados." | tee -a "$LOG_FILE"

echo "🩺 Verificación completada. Informe: $LOG_FILE"

