#!/bin/bash
# =====================================================
# 🧠 setup_godot_mono_auto.sh
# Instalador inteligente para Godot 4.5.1 Mono (.NET 8)
# Autor: Ricitos — RealmQuest Engine
# =====================================================

echo "🔧 Iniciando configuración automática de Godot Mono..."

# --- PASO 1: Eliminar versiones antiguas ---
echo "🧹 Eliminando versiones antiguas (snap / apt)..."
sudo snap remove godot4 godot4-mono gd-godot-engine-snapcraft 2>/dev/null
sudo apt remove --purge -y godot4 godot4-mono 2>/dev/null
sudo apt autoremove -y 2>/dev/null

# --- PASO 2: Buscar automáticamente el ejecutable Mono ---
echo "🔍 Buscando binarios de Godot Mono 4.5.1 o superior..."
BIN_PATH=$(find ~/ -type f -name "Godot_v4.*mono*64" 2>/dev/null | grep -E "x86_64$" | head -n 1)

if [ -z "$BIN_PATH" ]; then
  echo "❌ No se encontró ningún ejecutable de Godot Mono."
  echo "Por favor, descarga desde https://godotengine.org/download/linux/ → sección 'Mono / .NET'."
  exit 1
fi

echo "✅ Ejecutable encontrado en:"
echo "   $BIN_PATH"

# --- PASO 3: Instalar en /usr/local/bin ---
GODOT_DEST="/usr/local/bin/godot4"
echo "⚙️ Instalando en $GODOT_DEST ..."
sudo mv "$BIN_PATH" "$GODOT_DEST"
sudo chmod +x "$GODOT_DEST"

# --- PASO 4: Verificar instalación ---
echo "🧠 Verificando versión instalada..."
if godot4 --version | grep -q "v4"; then
  echo "✅ Versión detectada:"
  godot4 --version
else
  echo "⚠️ No se pudo verificar la versión. Revisa manualmente con 'godot4 --version'."
fi

# --- PASO 5: Buscar y configurar export templates ---
echo "📦 Buscando plantillas de exportación..."
TEMPLATE_PATH=$(find ~/ -type f -name "Godot_v4.*mono_export_templates.tpz" 2>/dev/null | head -n 1)

if [ -n "$TEMPLATE_PATH" ]; then
  echo "✅ Plantilla encontrada: $TEMPLATE_PATH"
  godot4 --install-template "$TEMPLATE_PATH"
else
  echo "⚠️ No se encontró archivo de plantillas (.tpz)."
  echo "Descárgalo desde la página oficial → sección Mono Export Templates."
fi

# --- PASO 6: Limpieza de configuraciones antiguas ---
echo "🧹 Limpiando configuraciones anteriores..."
rm -rf ~/.config/godot ~/.local/share/godot 2>/dev/null

# --- PASO 7: Confirmación final ---
echo "--------------------------------------"
echo "✅ Instalación completa de Godot Mono."
echo "Versión actual:"
godot4 --version
echo "Ubicación:"
which godot4
echo "--------------------------------------"
echo "🎯 Godot Mono está listo para RealmQuest Engine 🚀"

