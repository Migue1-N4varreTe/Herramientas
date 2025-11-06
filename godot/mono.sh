#!/usr/bin/env bash
# ============================================================
# 🧠 mono.sh — Ricitos Mono/.NET Auditor & Setup v2.0
# ------------------------------------------------------------
# Autor: Ricitos — LearnLab / RealmQuest Engine
# Fecha: 2025-10-31
# Descripción:
#   Diagnostica y repara el entorno Godot 4.x Mono (.NET 8):
#   ✅ Verifica godot4 (Mono), .NET SDK, GodotSharp y runtime
#   ✅ Opción --fix para aplicar correcciones típicas
#   ✅ Salida coloreada + logs mínimos en tiempo real
# Uso:
#   ./mono.sh           # Diagnóstico
#   ./mono.sh --fix     # Diagnóstico + correcciones
#   ./mono.sh --help    # Ayuda
# ============================================================

set -Eeuo pipefail

# -------------------- COLORES --------------------
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"
BLUE="\033[1;34m"; CYAN="\033[1;36m"; RESET="\033[0m"

ok()   { echo -e "${GREEN}✅ $*${RESET}"; }
warn() { echo -e "${YELLOW}⚠️  $*${RESET}"; }
err()  { echo -e "${RED}❌ $*${RESET}"; }
log()  { echo -e "${BLUE}[$(date +%H:%M:%S)]${RESET} $*"; }

# -------------------- FLAGS --------------------
DO_FIX=false
case "${1:-}" in
  --fix) DO_FIX=true ;;
  --help|-h)
    cat <<EOF
Uso:
  $(basename "$0")         -> Diagnóstico
  $(basename "$0") --fix   -> Diagnóstico + correcciones
EOF
    exit 0;;
esac

# -------------------- VARIABLES CLAVE --------------------
# Ajusta estas rutas si usas binario portable:
DEFAULT_GODOT_MONO_BIN="$HOME/Godot_4.5.1_Mono_Portable/Godot_v4.5.1-stable_mono_linux.x86_64"
GODOT_CMD="$(command -v godot4 || true)"  # puede estar vacío
GODOT_MONO_ASSEMBLIES_PATH_DEFAULT="$HOME/.local/share/godot/mono"
GODOTSHARP_HINT1="$HOME/.local/share/godot/mono/GodotSharp"
GODOTSHARP_HINT2="$HOME/Godot_4.5.1_Mono_Portable/GodotSharp"

line() { echo -e "${BLUE}------------------------------------------------------------${RESET}"; }

echo -e "${CYAN}🔍 Verificando entorno Godot + .NET (Mono)…${RESET}"
line

# ============================================================
# 1) GODOT MONO BINARIO
# ============================================================
if [[ -n "$GODOT_CMD" ]]; then
  ok "Binario godot4 en PATH: $GODOT_CMD"
else
  warn "No hay 'godot4' en PATH."
  if [[ -x "$DEFAULT_GODOT_MONO_BIN" ]]; then
    ok "Detectado binario portable: $DEFAULT_GODOT_MONO_BIN"
    if $DO_FIX; then
      log "Creando enlace simbólico /usr/local/bin/godot4 → portable"
      sudo ln -sf "$DEFAULT_GODOT_MONO_BIN" /usr/local/bin/godot4
      GODOT_CMD="/usr/local/bin/godot4"
      ok "Enlace creado: $(readlink -f /usr/local/bin/godot4)"
    fi
  else
    err "No se encontró Godot Mono. Descarga la versión Mono desde godotengine.org → Download → Mono/.NET."
  fi
fi

# ============================================================
# 2) VERSIÓN GODOT Y SOPORTE MONO
# ============================================================
HAS_MONO=false
if [[ -n "${GODOT_CMD:-}" ]]; then
  VERSION="$("$GODOT_CMD" --version 2>/dev/null || true)"
  if [[ -n "$VERSION" ]]; then
    log "Versión Godot: $VERSION"
    if grep -qi "mono" <<<"$VERSION"; then
      ok "Build con soporte .NET (Mono) activo."
      HAS_MONO=true
    else
      warn "Esta build parece NO incluir Mono (.NET)."
    fi
  else
    warn "No se pudo obtener la versión de Godot."
  fi
fi

# ============================================================
# 3) .NET SDK
# ============================================================
if dotnet --version >/dev/null 2>&1; then
  ok ".NET SDK detectado: v$(dotnet --version)"
else
  if $DO_FIX; then
    log "Instalando .NET SDK 8…"
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb >/dev/null 2>&1 || true
    sudo apt update -y && sudo apt install -y dotnet-sdk-8.0
    ok ".NET SDK 8 instalado."
  else
    err ".NET SDK no encontrado. Sugerencia: sudo apt install dotnet-sdk-8.0"
  fi
fi

# ============================================================
# 4) GODOTSHARP (ensamblados)
# ============================================================
GODOTSHARP_PATH=""
if [[ -d "$GODOTSHARP_HINT1" ]]; then
  GODOTSHARP_PATH="$GODOTSHARP_HINT1"
elif [[ -d "$GODOTSHARP_HINT2" ]]; then
  GODOTSHARP_PATH="$GODOTSHARP_HINT2"
fi

if [[ -n "$GODOTSHARP_PATH" ]]; then
  ok "GodotSharp localizado: $GODOTSHARP_PATH"
else
  warn "No se encontró carpeta GodotSharp en rutas comunes."
  if $DO_FIX; then
    # Si existe dentro del portable, copiar a local
    if [[ -d "$HOME/Godot_4.5.1_Mono_Portable/GodotSharp" ]]; then
      log "Copiando GodotSharp a $GODOT_MONO_ASSEMBLIES_PATH_DEFAULT/…"
      mkdir -p "$GODOT_MONO_ASSEMBLIES_PATH_DEFAULT"
      cp -r "$HOME/Godot_4.5.1_Mono_Portable/GodotSharp" "$GODOT_MONO_ASSEMBLIES_PATH_DEFAULT/"
      GODOTSHARP_PATH="$GODOT_MONO_ASSEMBLIES_PATH_DEFAULT/GodotSharp"
      ok "GodotSharp copiado a $GODOTSHARP_PATH"
    else
      err "No se pudo ubicar GodotSharp. Asegura que tu descarga Mono trae la carpeta 'GodotSharp'."
    fi
  else
    warn "Si tienes una descarga Mono, copia su carpeta 'GodotSharp' a: $GODOT_MONO_ASSEMBLIES_PATH_DEFAULT/"
  fi
fi

# ============================================================
# 5) VARIABLES DE ENTORNO (GODOT_MONO…)
# ============================================================
if [[ -n "$GODOTSHARP_PATH" ]]; then
  API_DIR="$GODOTSHARP_PATH/Api"
  if [[ -d "$API_DIR" ]]; then
    ok "Ensamblados API presentes: $API_DIR"
    if $DO_FIX; then
      if ! grep -q "GODOT_MONO_ASSEMBLIES_PATH" "$HOME/.bashrc"; then
        echo "export GODOT_MONO_ASSEMBLIES_PATH=\"$API_DIR\"" >> "$HOME/.bashrc"
        ok "Variable GODOT_MONO_ASSEMBLIES_PATH añadida a ~/.bashrc"
      else
        warn "GODOT_MONO_ASSEMBLIES_PATH ya existe en ~/.bashrc"
      fi
      # Export en sesión actual
      export GODOT_MONO_ASSEMBLIES_PATH="$API_DIR"
    fi
  else
    warn "No se encontró carpeta Api dentro de GodotSharp."
  fi
fi

# ============================================================
# 6) PRUEBA DE RUNTIME (headless)
# ============================================================
line
log "Probando inicialización de runtime Mono (.NET) en Godot…"
if [[ -n "${GODOT_CMD:-}" ]]; then
  if "$GODOT_CMD" --headless --version 2>&1 | grep -qi "mono"; then
    ok "Integración Godot + Mono verificada."
  else
    warn "El runtime Mono no reportó correctamente en --version headless."
    warn "Si persiste, prueba ejecutar un proyecto C# y revisa la consola de Godot."
  fi
else
  warn "No hay binario godot4 disponible para probar runtime."
fi

line
ok "Auditoría completada."
if $DO_FIX; then
  log "Se aplicaron correcciones cuando fue posible. Abre una nueva terminal para cargar variables de entorno."
fi

