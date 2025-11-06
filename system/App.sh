#!/bin/bash
# ────────────────────────────────────────────────
# 🚀 App.sh Pro – Instalador y Gestor de Apps Portables (Ricitos Edition)
# Autor: Ricitos
# Versión: 2.0 Pro (GUI + pkexec + gestión visual)
# Requiere: Zenity
# ────────────────────────────────────────────────

# Verifica Zenity
if ! command -v zenity &>/dev/null; then
  echo "❌ Zenity no está instalado. Ejecuta: sudo apt install zenity"
  exit 1
fi

# ────────────────────────────────────────────────
# 🧩 Funciones principales
# ────────────────────────────────────────────────

create_app() {
  APP_NAME=$(zenity --entry --title="🧩 Nombre de la aplicación" --text="Introduce el nombre visible en el menú:")
  [[ -z "$APP_NAME" ]] && exit 1

  APP_EXEC=$(zenity --file-selection --title="📦 Selecciona el ejecutable o AppImage")
  [[ -z "$APP_EXEC" ]] && exit 1

  APP_ICON=$(zenity --file-selection --title="🎨 Selecciona el ícono (opcional)")
  APP_CATEGORIES=$(zenity --entry --title="📁 Categorías" --text="Ejemplo: Development;Utility;AI;" --entry-text="Utility;")
  APP_COMMENT=$(zenity --entry --title="💬 Descripción" --text="Descripción breve de la app:" --entry-text="Aplicación registrada con App.sh")

  DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME// /_}.desktop"

  cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$APP_EXEC
Icon=$APP_ICON
Type=Application
Categories=$APP_CATEGORIES
Comment=$APP_COMMENT
Terminal=false
StartupNotify=true
StartupWMClass=${APP_NAME,,}
EOF

  chmod +x "$APP_EXEC"
  chmod +x "$DESKTOP_FILE"

  update-desktop-database ~/.local/share/applications
  sudo update-icon-caches /usr/share/icons/hicolor 2>/dev/null || true

  zenity --info --title="✅ App registrada" \
  --text="La aplicación <b>$APP_NAME</b> ha sido agregada al menú correctamente."
}

# ────────────────────────────────────────────────
# 🧹 Desinstalar aplicación
# ────────────────────────────────────────────────
remove_app() {
  FILE=$(zenity --file-selection --title="🧹 Selecciona la app (.desktop) a eliminar" --filename="$HOME/.local/share/applications/")
  [[ -z "$FILE" ]] && exit 1
  APP_NAME=$(basename "$FILE" .desktop)
  rm "$FILE"
  zenity --info --text="🗑️ '$APP_NAME' ha sido eliminada del menú."
}

# ────────────────────────────────────────────────
# 📋 Listar y gestionar aplicaciones
# ────────────────────────────────────────────────
manage_apps() {
  FILES=$(ls ~/.local/share/applications/*.desktop 2>/dev/null)
  if [[ -z "$FILES" ]]; then
    zenity --info --text="⚠️ No hay apps portables registradas aún."
    exit 0
  fi

  APP=$(zenity --list --title="📋 Gestor de Apps Portables" \
  --column="Aplicaciones" $(basename -a $FILES) --height=400 --width=500)
  
  [[ -z "$APP" ]] && exit 0
  FILE="$HOME/.local/share/applications/$APP"

  ACTION=$(zenity --list --title="⚙️ Acciones para $APP" \
  --column="Acción" "Ver contenido" "Editar manualmente" "Eliminar" --height=200 --width=300)

  case $ACTION in
    "Ver contenido") zenity --text-info --title="📄 Contenido de $APP" --filename="$FILE" ;;
    "Editar manualmente") nano "$FILE" ;;
    "Eliminar") rm "$FILE"; zenity --info --text="🗑️ '$APP' eliminada." ;;
  esac
}

# ────────────────────────────────────────────────
# 📤 Exportar entradas
# ────────────────────────────────────────────────
export_apps() {
  DEST=$(zenity --file-selection --save --confirm-overwrite --title="📤 Exportar lista de apps registradas")
  [[ -z "$DEST" ]] && exit 1
  cp ~/.local/share/applications/*.desktop "$DEST"
  zenity --info --text="📦 Exportación completada a: $DEST"
}

# ────────────────────────────────────────────────
# 🧰 Modo Global (requiere pkexec)
# ────────────────────────────────────────────────
install_global() {
  zenity --info --text="🌍 Este modo instalará la app para <b>todos los usuarios</b>."
  pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "$(declare -f create_app); create_app"
}

# ────────────────────────────────────────────────
# 🎛️ Menú principal
# ────────────────────────────────────────────────
main_menu() {
  CHOICE=$(zenity --list --title="🧠 App Installer Ricitos Pro" \
  --text="Selecciona una acción:" \
  --column="Opción" \
  "➕ Registrar nueva App" \
  "🗑️ Desinstalar App" \
  "📋 Gestionar Apps" \
  "📤 Exportar Apps" \
  "🌍 Instalar App Globalmente" \
  "❌ Salir" \
  --height=320 --width=400)

  case $CHOICE in
    "➕ Registrar nueva App") create_app ;;
    "🗑️ Desinstalar App") remove_app ;;
    "📋 Gestionar Apps") manage_apps ;;
    "📤 Exportar Apps") export_apps ;;
    "🌍 Instalar App Globalmente") install_global ;;
    "❌ Salir") exit 0 ;;
  esac
}

# Ejecutar menú
main_menu

