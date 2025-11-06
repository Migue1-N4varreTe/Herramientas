#!/usr/bin/env bash
# ============================================================
# 🧩 Compile.sh — RealmQuest Engine Build Manager v2.0
# ------------------------------------------------------------
# Autor: Ricitos — LearnLab / RealmQuest Engine
# Fecha: 2025-10-31
# Descripción:
#   Sistema de compilación modular para RealmQuest Engine 4.5.1.
#   Permite instalar dependencias, limpiar builds, actualizar
#   repos, generar bindings y compilar extensiones nativas.
# ============================================================

set -Eeuo pipefail

# ============================================================
# ⚙️ CONFIGURACIÓN GENERAL
# ============================================================
PROJECT_DIR="RealmQuest_Engine_4_5_1"
CPP_DIR="godot-cpp"
NATIVE_DIR="$PROJECT_DIR/systems/native"
LOG_FILE="Compile.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# ============================================================
# 🎨 COLORES Y FORMATO
# ============================================================
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

log() { echo -e "${BLUE}[$(date +"%H:%M:%S")]${RESET} $1" | tee -a "$LOG_FILE"; }
ok() { echo -e "${GREEN}✅ $1${RESET}" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}⚠️  $1${RESET}" | tee -a "$LOG_FILE"; }
err() { echo -e "${RED}❌ $1${RESET}" | tee -a "$LOG_FILE"; }

# ============================================================
# 🧠 FUNCIÓN DE DIAGNÓSTICO DE DEPENDENCIAS
# ============================================================
check_dependencies() {
  local deps=("git" "scons" "python3" "clang" "wget")
  log "🔍 Verificando dependencias..."
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      warn "Dependencia faltante: $dep"
      MISSING_DEPS=true
    fi
  done

  if [ "${MISSING_DEPS:-false}" = true ]; then
    warn "Instalando dependencias requeridas..."
    sudo apt update -y && sudo apt install -y git scons python3 python3-pip build-essential clang wget
  fi
  ok "Dependencias verificadas."
}

# ============================================================
# 🧹 LIMPIEZA DE BUILDS
# ============================================================
clean_all() {
  log "🧹 Limpiando compilaciones previas..."
  rm -rf "$CPP_DIR/bin" "$CPP_DIR/include/godot_cpp" "$CPP_DIR/gen" "$NATIVE_DIR/bin" 2>/dev/null || true
  find "$PROJECT_DIR" -name "*.o" -delete 2>/dev/null || true
  ok "Limpieza completa."
}

# ============================================================
# 🔎 DIAGNÓSTICO DE ENTORNO
# ============================================================
diagnose_env() {
  line
  log "🔎 Diagnóstico del entorno RealmQuest"
  echo "🧩 OS:" "$(lsb_release -ds 2>/dev/null || echo 'Desconocido')"
  echo "🧱 C++:" "$(clang --version | head -n 1 2>/dev/null || echo 'No detectado')"
  echo "🐍 Python:" "$(python3 --version 2>/dev/null || echo 'No detectado')"
  echo "⚙️  SCons:" "$(scons --version | head -n 1 2>/dev/null || echo 'No detectado')"
  echo ""
  [ -d "$CPP_DIR" ] && ok "godot-cpp presente." || warn "No se encontró godot-cpp."
  [ -d "$NATIVE_DIR" ] && ok "Directorio systems/native detectado." || warn "No se encontró carpeta nativa."
}

# ============================================================
# 🔄 ACTUALIZAR REPOSITORIOS
# ============================================================
update_all() {
  log "🔄 Actualizando repositorios..."
  if [ -d "$CPP_DIR" ]; then
    (cd "$CPP_DIR" && git fetch origin && git pull origin 4.5 || true)
    if [ -d "$CPP_DIR/godot-headers" ]; then
      (cd "$CPP_DIR/godot-headers" && git pull origin master || true)
    fi
    ok "Repositorios actualizados."
  else
    warn "No se encontró carpeta godot-cpp. Clonando..."
    git clone https://github.com/godotengine/godot-cpp.git "$CPP_DIR"
  fi
}

# ============================================================
# 🏗️ COMPILAR GODOT-CPP
# ============================================================
build_cpp() {
  log "⚙️  Compilando godot-cpp (4.5)..."
  cd "$CPP_DIR"
  git fetch origin
  git checkout 4.5 || git checkout godot-4.5-stable
  [ ! -d "godot-headers" ] && git clone https://github.com/godotengine/godot-headers.git
  wget -q https://raw.githubusercontent.com/godotengine/godot/4.5-stable/modules/gdextension/extension_api.json -O godot-headers/extension_api.json
  scons platform=linux target=template_debug generate_bindings=yes
  cd ..
  ok "godot-cpp compilado correctamente."
}

# ============================================================
# 🧱 COMPILAR EXTENSIÓN NATIVA
# ============================================================
build_native() {
  log "🛠️  Compilando extensión nativa RealmQuest..."
  cd "$NATIVE_DIR"
  scons platform=linux target=template_debug
  cd - >/dev/null
  ok "Extensión compilada correctamente."
}

# ============================================================
# 🧩 CREAR ESTRUCTURA SI FALTA
# ============================================================
create_structure() {
  log "📁 Preparando estructura del proyecto..."
  mkdir -p "$NATIVE_DIR/src" "$NATIVE_DIR/bin"
  [ ! -d "$PROJECT_DIR/$CPP_DIR" ] && cp -r "$CPP_DIR" "$PROJECT_DIR/"
  
  # Archivo de ejemplo nativo
  cat > "$NATIVE_DIR/src/Example.cpp" << 'EOF'
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/utility_functions.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

class Example : public Node {
    GDCLASS(Example, Node);
protected:
    static void _bind_methods() {
        ClassDB::bind_method(D_METHOD("say_hello"), &Example::say_hello);
    }
public:
    void say_hello() {
        UtilityFunctions::print("🌟 Hello from RealmQuest Native Module (C++)!");
    }
};

extern "C" GDExtensionBool GDE_EXPORT myextension_library_init(
    GDExtensionInterfaceGetProcAddress get_proc_address,
    GDExtensionClassLibraryPtr library,
    GDExtensionInitialization *init) {
    GDExtensionBinding::InitObject init_obj(get_proc_address, library, init);
    init_obj.register_initializer([](ModuleInitializationLevel level) {
        if (level == MODULE_INITIALIZATION_LEVEL_SCENE) {
            GDREGISTER_CLASS(Example);
        }
    });
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    return init_obj.init();
}
EOF

  # Archivos de build
  cat > "$NATIVE_DIR/SConstruct" << 'EOF'
import os
env = Environment()
GODOT_CPP_PATH = '../godot-cpp'
env.Append(CPPPATH=[
    f'{GODOT_CPP_PATH}/include',
    f'{GODOT_CPP_PATH}/include/godot_cpp',
    f'{GODOT_CPP_PATH}/gen/include',
])
env.Append(LIBPATH=[f'{GODOT_CPP_PATH}/bin'])
env.Append(LIBS=['godot-cpp.linux.template_debug.x86_64'])
sources = Glob('src/*.cpp')
target = 'bin/librealmquest_extension.linux.template_debug.x86_64'
env.SharedLibrary(target=target, source=sources)
EOF

  cat > "$NATIVE_DIR/realmquest_extension.gdextension" << 'EOF'
[configuration]
entry_symbol = "myextension_library_init"
compatibility_minimum = "4.5"

[libraries]
linux.debug.x86_64 = "res://systems/native/bin/librealmquest_extension.linux.template_debug.x86_64.so"
linux.release.x86_64 = "res://systems/native/bin/librealmquest_extension.linux.template_release.x86_64.so"
EOF

  ok "Estructura de proyecto lista."
}

# ============================================================
# 🚀 COMPILACIÓN COMPLETA
# ============================================================
full_build() {
  log "🚀 Iniciando build completo de RealmQuest Engine..."
  check_dependencies
  update_all
  build_cpp
  create_structure
  build_native
  ok "🎯 Build finalizado. Binario en: $NATIVE_DIR/bin/"
}

# ============================================================
# 🧭 CONTROL DE ARGUMENTOS
# ============================================================
case "${1:-}" in
  clean)     clean_all ;;
  rebuild)   clean_all; full_build ;;
  update)    update_all ;;
  test)      build_native ;;
  diagnose)  diagnose_env ;;
  *)         full_build ;;
esac

ok "🌟 Compile.sh completado. Revisa Compile.log para detalles."

