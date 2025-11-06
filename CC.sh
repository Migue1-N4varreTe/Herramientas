#!/usr/bin/env bash
# ============================================================
# 🔮 Command Core (CC) v4.3 — Núcleo completo
# ============================================================

set -Eeuo pipefail
IFS=$'\n\t'

CC_NAME="Command Core"
CC_VERSION="4.3"
CC_BANNER="🔮 Command Core (CC) v${CC_VERSION}"

# Paths
CC_HOME="${CC_HOME:-$HOME/CC}"
CORE_DIR="$CC_HOME/core"
DEPLOY_DIR="$CC_HOME/deploy"
GODOT_DIR="$CC_HOME/godot"
MAINT_DIR="$CC_HOME/maintenance"
SYSTEM_DIR="$CC_HOME/system"
TELEMETRY_DIR="$CC_HOME/telemetry"
GUI_DIR="$CC_HOME/gui"

LOG_DIR="${LOG_DIR:-$HOME/command_core_logs}"
REPORT_DIR="${REPORT_DIR:-$LOG_DIR/visual_reports}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/CommandCore_Backups}"

mkdir -p "$CC_HOME" "$CORE_DIR" "$DEPLOY_DIR" "$GODOT_DIR" "$MAINT_DIR" "$SYSTEM_DIR" "$TELEMETRY_DIR" "$GUI_DIR" "$LOG_DIR" "$REPORT_DIR" "$BACKUP_DIR"

# Colors
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"
BLUE="\033[1;34m"; CYAN="\033[1;36m"; RESET="\033[0m"
ok(){ echo -e "${GREEN}✅ $*${RESET}"; }
warn(){ echo -e "${YELLOW}⚠️  $*${RESET}"; }
err(){ echo -e "${RED}❌ $*${RESET}"; }
log(){ echo -e "${BLUE}[$(date +%F\ %H:%M:%S)]${RESET} $*"; }

header(){
  echo -e "\n${CYAN}${CC_BANNER}${RESET}"
  echo -e "${BLUE}──────────────────────────────────────────────────────────${RESET}\n"
}

# Projects
PROJECT_PATHS=(
  "$HOME/Projects/mindmirror"
  "$HOME/Projects/economica"
  "$HOME/Projects/iconolab"
  "$HOME/Projects/admin-economica"
  "$HOME/Projects/MODLR"
  "$HOME/Projects/facturify"
  "$HOME/Projects/learnlabstudio-site"
  "$HOME/Projects/mail-manager"
  "$HOME/RealmQuest_Engine_4_5_1"
)

# Context loader
PROJECT_FILE=""
find_project_file(){
  local d="$PWD"
  while [[ "$d" != "/" ]]; do
    if [[ -f "$d/.ricitos_project" ]]; then PROJECT_FILE="$d/.ricitos_project"; return 0; fi
    d="$(dirname "$d")"
  done
  return 1
}
load_context(){
  if find_project_file; then
    source "$PROJECT_FILE" || true
    : "${PROJECT_NAME:=Unnamed}"
    : "${PROJECT_TYPE:=web}"
    header
    echo -e "📁 ${CYAN}Proyecto:${RESET} $PROJECT_NAME"
    echo -e "📦 ${CYAN}Tipo:${RESET} $PROJECT_TYPE"
    [[ -n "${PROJECT_DOMAIN:-}" ]] && echo -e "🌐 ${CYAN}Dominio:${RESET} $PROJECT_DOMAIN"
    echo ""
    return 0
  else
    header; warn "No se detectó .ricitos_project — usando modo global."
    return 1
  fi
}

# Script resolver
resolve_script(){
  local rel="$1"
  local candidates=(
    "$CC_HOME/$rel"
    "$CORE_DIR/${rel##*/}"
    "$DEPLOY_DIR/${rel##*/}"
    "$GODOT_DIR/${rel##*/}"
    "$MAINT_DIR/${rel##*/}"
    "$SYSTEM_DIR/${rel##*/}"
    "$TELEMETRY_DIR/${rel##*/}"
    "$GUI_DIR/${rel##*/}"
    "./$rel"
    "$PWD/$rel"
  )
  for c in "${candidates[@]}"; do
    [[ -f "$c" ]] && { printf '%s' "$c"; return 0; }
  done
  return 1
}

run_module(){
  local rel="$1"; shift || true
  local script
  if script="$(resolve_script "$rel")"; then
    log "Ejecutando → $script $*"
    bash "$script" "$@" &
    disown
    return $?
  else
    warn "Módulo no encontrado: $rel"
    return 1
  fi
}

# -------------------------------
# Fallback commands
# -------------------------------
cmd_status(){
  header
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime -p)"
  echo "Kernel: $(uname -r)"
  echo "CPU: $(lscpu 2>/dev/null | awk -F: '/Model name/{print $2}' | xargs || echo 'N/D')"
  echo "Load: $(cut -d' ' -f1-3 /proc/loadavg)"
  echo "RAM: $(free -h | awk '/Mem:/ {print $3\"/\"$2}')"
  echo "Disk /: $(df -h / | tail -1 | awk '{print $3\" used of \"$2\" (\"$5\")\"}')"
  echo ""
  [[ -d "$LOG_DIR" ]] && echo "Logs: $LOG_DIR"
  ok "Resumen generado."
}

cmd_syscheck(){
  header
  echo -e "🔎 Syscheck — dependencias y servicios\n"
  local deps=(git curl rsync node pnpm dotnet godot4 docker)
  for d in "${deps[@]}"; do
    if command -v "$d" >/dev/null 2>&1; then
      echo "✅ $d — $( "$d" --version 2>/dev/null | head -n1 || command -v $d )"
    else
      warn "$d no instalado"
    fi
  done
}

# GUI & TUI
launch_gui(){
  local theme="${1:-neon}"
  if [[ -n "${DISPLAY:-}" ]] && command -v python3 >/dev/null 2>&1; then
    if [[ -f "$GUI_DIR/cc_dashboard.py" ]]; then
      python3 "$GUI_DIR/cc_dashboard.py" "$theme" &
      disown
      ok "GUI iniciada en segundo plano con tema: $theme"
    else
      warn "GUI no encontrada en $GUI_DIR/cc_dashboard.py"
      launch_tui
    fi
  else
    log "No display detectado. Lanzando modo TUI."
    launch_tui
  fi
}

launch_tui(){
  header
  echo "🔹 TUI: Panel de comando interactivo"
  PS3="Selecciona opción: "
  options=("status" "syscheck" "metrics" "deploy" "auto-backup" "system-update" "exit")
  select opt in "${options[@]}"; do
    case $opt in
      "status") cmd_status ;;
      "syscheck") cmd_syscheck ;;
      "metrics") cmd_metrics ;;
      "deploy") run_module "deploy/deploy.sh" || cmd_deploy_sync ;;
      "auto-backup") cmd_auto_backup ;;
      "system-update") cmd_system_update ;;
      "exit") break ;;
      *) echo "Opción inválida";;
    esac
  done
}

# -------------------------------
# Help dinámico
# -------------------------------
show_help(){
  header
  cat <<EOF
📖 Comandos disponibles (CC v4.3)
────────────────────────────────
Core:
  init <perfil>
  build [rebuild|diagnose]
  dev
  deploy
  update [all]
  update-core

Maintenance:
  repair [gui]
  maintain [normal|deep|gui]
  system-repair
  optimize

Backup:
  backup [restore <file>]
  auto-backup

Deploy / Sync:
  deploy-sync
  staging
  netlify
  render

Telemetry & Metrics:
  metrics [gui]
  metrics-report
  telemetry-scan
  telemetry-report
  telemetry-clean

System:
  status
  syscheck
  check-dev
  system-info
  user-audit
  sync
  export
  system-update
  system-health
  check-disk
  rotate-logs

Other:
  gui
  gui-safe [dark|neon]
  notify <msg>
  help
EOF
}

# -------------------------------
# ROUTER
# -------------------------------
CMD="${1:-help}"; SUB="${2:-}"; shift 2 2>/dev/null || true
load_context || true

case "$CMD" in
  gui-safe) launch_gui "$SUB" ;;
  gui) launch_gui ;;
  status) cmd_status ;;
  syscheck) cmd_syscheck ;;
  help|--help|-h) show_help ;;
  *)
    warn "Comando desconocido: $CMD"
    show_help ;;
esac

echo -e "${BLUE}\n──────────────────────────────────────────────────────────${RESET}"
ok "Operación finalizada."

