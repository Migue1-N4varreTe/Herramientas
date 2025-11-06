#!/usr/bin/env bash
# ============================================================
# ⚙️ Ricitos System Check & Upgrade Pro v2.0
# ------------------------------------------------------------
# Autor: Ricitos — LearnLab / RealmQuest Engine
# Fecha: 2025-10-31
# Descripción:
#   Diagnóstico integral del entorno técnico de desarrollo:
#   ✅ Godot, .NET, Mesa, GPU, Vulkan y Kernel
#   ✅ PATH y alias
#   ✅ Opción de actualización automática
#   ✅ Registro histórico con colores y formato visual
# ============================================================

# -------------------- CONFIGURACIÓN BÁSICA --------------------
LOG_DIR="$HOME/ricitos_system_logs"
LOG_FILE="$LOG_DIR/system_check_$(date +'%Y-%m-%d_%H-%M-%S').log"
AUTO_MODE=false

# -------------------- COLORES --------------------
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"
line() { echo -e "${BLUE}------------------------------------------------------------${RESET}"; }

# -------------------- PARÁMETROS --------------------
if [[ "$1" == "--auto" ]]; then
  AUTO_MODE=true
fi

mkdir -p "$LOG_DIR"
echo "=== Ricitos System Check $(date '+%Y-%m-%d %H:%M:%S') ===" > "$LOG_FILE"

echo -e "${CYAN}🚀 Iniciando Ricitos System Check & Upgrade Pro...${RESET}"
line

# ============================================================
# 🧩 1️⃣ VERIFICAR GODOT
# ============================================================
if command -v godot4 &> /dev/null; then
  GODOT_VERSION=$(godot4 --version | head -n 1)
  echo -e "${GREEN}✅ Godot detectado:${RESET} $GODOT_VERSION"
  echo "Godot: $GODOT_VERSION" >> "$LOG_FILE"
else
  echo -e "${RED}❌ Godot no encontrado.${RESET}"
  echo "Godot: No encontrado" >> "$LOG_FILE"
fi

# ============================================================
# ⚙️ 2️⃣ VERIFICAR .NET
# ============================================================
if command -v dotnet &> /dev/null; then
  DOTNET_VERSION=$(dotnet --version)
  echo -e "${GREEN}✅ .NET SDK detectado:${RESET} v$DOTNET_VERSION"
  echo ".NET SDK: v$DOTNET_VERSION" >> "$LOG_FILE"
else
  echo -e "${RED}❌ .NET SDK no encontrado.${RESET}"
  echo ".NET SDK: No detectado" >> "$LOG_FILE"
  echo "Sugerencia: sudo apt install dotnet-sdk-8.0" >> "$LOG_FILE"
fi

# ============================================================
# 🧱 3️⃣ GPU, OpenGL y Render
# ============================================================
GPU_INFO=$(lspci | grep -Ei 'vga|3d|display' || echo "No detectada")
MESA_VERSION=$(glxinfo | grep "OpenGL version" 2>/dev/null | cut -d: -f2 | xargs || echo "Desconocido")
RENDERER=$(glxinfo | grep "OpenGL renderer" 2>/dev/null | cut -d: -f2 | xargs || echo "Desconocido")

echo -e "${GREEN}🧩 GPU:${RESET} $GPU_INFO"
echo -e "${CYAN}🖼  OpenGL:${RESET} $MESA_VERSION"
echo -e "${CYAN}🎮 Renderer:${RESET} $RENDERER"
{
  echo "GPU: $GPU_INFO"
  echo "OpenGL: $MESA_VERSION"
  echo "Renderer: $RENDERER"
} >> "$LOG_FILE"

if echo "$RENDERER" | grep -qi "llvmpipe"; then
  echo -e "${RED}⚠️  Render por software (llvmpipe) detectado.${RESET}"
else
  echo -e "${GREEN}✅ Renderizado por hardware activo.${RESET}"
fi

# ============================================================
# 🧠 4️⃣ KERNEL y VULKAN
# ============================================================
KERNEL=$(uname -r)
echo -e "${CYAN}🧱 Kernel actual:${RESET} $KERNEL"
echo "Kernel: $KERNEL" >> "$LOG_FILE"

if command -v vulkaninfo &> /dev/null; then
  VULKAN_VERSION=$(vulkaninfo | grep "Vulkan Instance Version" | head -n 1 | awk '{print $4}')
  echo -e "${GREEN}🧠 Vulkan detectado:${RESET} v$VULKAN_VERSION"
else
  echo -e "${YELLOW}ℹ️  Vulkan no instalado.${RESET}"
fi

# ============================================================
# 🧩 5️⃣ VALIDAR PATH
# ============================================================
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
  echo -e "${GREEN}✅ PATH incluye ~/.local/bin${RESET}"
else
  echo -e "${RED}⚠️  PATH no incluye ~/.local/bin${RESET}"
  echo "Sugerencia: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
fi

# ============================================================
# 🔄 6️⃣ ACTUALIZACIÓN (OPCIONAL o AUTO)
# ============================================================
line
if [[ "$AUTO_MODE" = true ]]; then
  echo -e "${YELLOW}⚙️  Modo automático: actualizando sistema...${RESET}"
  sudo apt update -y && sudo apt full-upgrade -y
  echo -e "${GREEN}✅ Sistema actualizado.${RESET}"
else
  read -rp "¿Deseas actualizar Mesa, .NET y el sistema ahora? (s/n): " REPLY
  if [[ "$REPLY" =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}📦 Actualizando sistema...${RESET}"
    sudo apt update && sudo apt full-upgrade -y
    echo -e "${GREEN}✅ Sistema actualizado.${RESET}"
  else
    echo -e "${CYAN}⏭  Saltando actualización automática.${RESET}"
  fi
fi

# ============================================================
# 📊 7️⃣ RESUMEN FINAL
# ============================================================
line
echo -e "${CYAN}📊 RESUMEN DEL ESTADO ACTUAL${RESET}"
echo -e "• Godot: ${GODOT_VERSION:-No detectado}"
echo -e "• .NET SDK: ${DOTNET_VERSION:-No detectado}"
echo -e "• GPU: ${GPU_INFO:-Desconocida}"
echo -e "• OpenGL: ${MESA_VERSION:-Desconocido}"
echo -e "• Renderer: ${RENDERER:-Desconocido}"
echo -e "• Kernel: ${KERNEL}"
line
echo -e "${GREEN}🎉 Auditoría completada.${RESET}"
echo -e "📁 Registro: ${YELLOW}$LOG_FILE${RESET}"
echo ""

