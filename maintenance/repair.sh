#!/usr/bin/env bash
# ============================================================
# 🔧 Ricitos System Repair Pro v2.0
# ------------------------------------------------------------
# Autor: Ricitos — LearnLab / RealmQuest Engine
# Fecha: 2025-10-31
# Descripción:
#   Repara el entorno Godot 4.5.1 Mono (.NET 8)
#   ✅ Verifica e instala .NET 8 SDK
#   ✅ Reconstruye GodotSharp en /usr/local
#   ✅ Corrige variables de entorno y permisos
#   ✅ Limpia y revalida ensamblados
# Uso:
#   ./repair.sh           → diagnóstico y reparación guiada
#   ./repair.sh --auto    → modo automático (sin preguntas)
# ============================================================

set -Eeuo pipefail

# -------------------- COLORES --------------------
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"
BLUE="\033[1;34m"; CYAN="\033[1;36m"; RESET="\033[0m"

ok()   { echo -e "${GREEN}✅ $*${RESET}"; }
warn() { echo -e "${YELLOW}⚠️  $*${RESET}"; }
err()  { echo -e "${RED}❌ $*${RESET}"; }
log()  { echo -e "${BLUE}[$(date +%H:%M:%S)]${RESET} $*"; }
line() { echo -e "${BLUE}------------------------------------------------------------${RESET}"; }

AUTO=false
[[ "${1:-}" == "--auto" ]] && AUTO=true

echo -e "${CYAN}🔧 Iniciando reparación del entorno Godot Mono (.NET 8)…${RESET}"
line

# ============================================================
# 1️⃣ .NET SDK 8
# ============================================================
if dotnet --list-sdks 2>/dev/null | grep -q "8.0"; then
  ok ".NET SDK 8 detectado."
else
  warn ".NET SDK 8 no encontrado."
  if $AUTO; then
    log "Instalando .NET SDK 8…"
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb >/dev/null 2>&1 || true
    sudo apt update -y && sudo apt install -y dotnet-sdk-8.0
    ok ".NET SDK 8 instalado."
  else
    read -rp "¿Deseas instalar .NET 8 ahora? (s/n): " r
    [[ "$r" =~ ^[Ss]$ ]] && $0 --auto && exit 0 || warn "Instalación omitida."
  fi
fi

# ============================================================
# 2️⃣ Localizar GodotSharp
# ============================================================
CANDIDATES=(
  "$HOME/Godot_4.5.1_Mono_Portable/GodotSharp/Api/Debug"
  "$HOME/.local/share/godot/mono/GodotSharp/Api/Debug"
  "/usr/local/GodotSharp/Api/Debug"
)
FOUND=""
for c in "${CANDIDATES[@]}"; do
  [[ -d "$c" ]] && FOUND="$c" && break
done

if [[ -z "$FOUND" ]]; then
  err "No se encontró carpeta GodotSharp/Api/Debug."
  warn "Descarga Godot Mono y copia su carpeta GodotSharp a ~/.local/share/godot/mono/"
  exit 1
fi
ok "GodotSharp localizado en: ${FOUND%/Api/Debug}"

# ============================================================
# 3️⃣ Copiar a /usr/local/GodotSharp
# ============================================================
log "Sincronizando GodotSharp en /usr/local/GodotSharp…"
sudo rm -rf /usr/local/GodotSharp 2>/dev/null || true
sudo mkdir -p /usr/local/GodotSharp
sudo cp -r "${FOUND%/Api/Debug}" /usr/local/
sudo chown -R root:root /usr/local/GodotSharp
sudo chmod -R 755 /usr/local/GodotSharp
ok "GodotSharp actualizado en /usr/local."

# ============================================================
# 4️⃣ Variable de entorno
# ============================================================
if ! grep -q "GODOT_MONO_ASSEMBLIES_PATH" "$HOME/.bashrc"; then
  echo 'export GODOT_MONO_ASSEMBLIES_PATH="/usr/local/GodotSharp/Api"' >> "$HOME/.bashrc"
  ok "Variable GODOT_MONO_ASSEMBLIES_PATH añadida a ~/.bashrc"
else
  warn "Variable GODOT_MONO_ASSEMBLIES_PATH ya presente en ~/.bashrc"
fi
export GODOT_MONO_ASSEMBLIES_PATH="/usr/local/GodotSharp/Api"

# ============================================================
# 5️⃣ Verificar integridad de ensamblados
# ============================================================
if ls /usr/local/GodotSharp/Api/Debug/*.dll >/dev/null 2>&1; then
  ok "Ensamblados .NET encontrados correctamente."
else
  err "No se detectaron DLLs en /usr/local/GodotSharp/Api/Debug"
  warn "Copia manualmente los archivos DLL desde tu instalación de Godot Mono."
fi

# ============================================================
# 6️⃣ Validar Godot Mono
# ============================================================
if command -v godot4 >/dev/null 2>&1; then
  log "Probando versión de Godot Mono…"
  if godot4 --version | grep -qi "mono"; then
    ok "Godot Mono funcional."
  else
    warn "Godot 4 no parece tener soporte Mono; verifica el binario."
  fi
else
  err "No se encontró comando godot4."
fi

# ============================================================
# 7️⃣ Finalización
# ============================================================
line
ok "Reparación completada."
echo -e "${CYAN}Reinicia tu terminal para aplicar variables de entorno.${RESET}"
line

