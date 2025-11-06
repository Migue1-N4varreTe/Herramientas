#!/usr/bin/env bash
# ============================================================
# 🧩 Ricitos System Uninstaller v2.0
# ------------------------------------------------------------
# Autor: Ricitos — LearnLab / RealmQuest Engine
# Fecha: 2025-10-31
# Descripción:
#   Desinstala el entorno actual y limpia su contenido.
#   Confirma antes de eliminar, valida rutas y muestra
#   mensajes colorizados con estado visual.
# Uso:
#   ./uninstall.sh           → modo interactivo (pide confirmación)
#   ./uninstall.sh --force   → desinstalación sin confirmación
# ============================================================

set -Eeuo pipefail

# 🎨 Colores
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"
BLUE="\033[1;34m"; CYAN="\033[1;36m"; RESET="\033[0m"

ok()   { echo -e "${GREEN}✅ $*${RESET}"; }
warn() { echo -e "${YELLOW}⚠️  $*${RESET}"; }
err()  { echo -e "${RED}❌ $*${RESET}"; }
log()  { echo -e "${BLUE}[$(date +%H:%M:%S)]${RESET} $*"; }

# 📁 Directorio de instalación detectado
INSTDIR=$(cd "$(dirname "$0")" && pwd)
FORCE=false
[[ "${1:-}" == "--force" ]] && FORCE=true

log "🧩 Desinstalador Ricitos System iniciado"
log "Directorio detectado: ${CYAN}${INSTDIR}${RESET}"
echo ""

if ! [[ -x "${INSTDIR}/_conda" ]]; then
  err "No se encontró el ejecutable '_conda' en ${INSTDIR}"
  exit 1
fi

# 🔐 Confirmación
if ! $FORCE; then
  echo -e "${YELLOW}¿Deseas desinstalar todo el contenido de:${RESET}"
  echo -e "   ${BLUE}${INSTDIR}${RESET}"
  echo -e "${YELLOW}Esto eliminará todos los archivos asociados.${RESET}"
  read -rp "[Escribe 'YES' para confirmar] >>> " ANSWER
  if [[ "${ANSWER}" != "YES" ]]; then
    warn "Desinstalación cancelada por el usuario."
    exit 2
  fi
else
  log "Modo forzado activado — omitiendo confirmación."
fi

# 🧹 Ejecución de desinstalación
log "Ejecutando desinstalador interno..."
if "${INSTDIR}/_conda" constructor uninstall --prefix "${INSTDIR}" "$@" >/dev/null 2>&1; then
  ok "Desinstalación completada correctamente."
else
  err "Fallo al ejecutar desinstalador interno."
  exit 3
fi

# 🧽 Limpieza opcional
read -rp "¿Deseas eliminar completamente el directorio ${INSTDIR}? (s/n): " CLEAN
if [[ "$CLEAN" =~ ^[SsYy]$ ]]; then
  rm -rf "${INSTDIR}"
  ok "Directorio eliminado."
else
  warn "El directorio no fue eliminado (puedes hacerlo manualmente)."
fi

log "🧠 Desinstalador Ricitos System finalizado."

