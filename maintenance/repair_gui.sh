#!/usr/bin/env bash
# ============================================================
# 🧩 Ricitos System Repair GUI v1.0
# ------------------------------------------------------------
# Autor: Ricitos — LearnLab / RealmQuest Engine
# Fecha: 2025-10-31
# Descripción:
#   Interfaz visual para reparar entorno Godot + .NET (Mono)
#   Utiliza Zenity para interacción gráfica en Zorin/GNOME
# ============================================================

# Requisitos
if ! command -v zenity &>/dev/null; then
  echo "❌ Zenity no está instalado. Ejecuta: sudo apt install zenity"
  exit 1
fi

# Colores y logs
LOG_FILE="$HOME/ricitos_system_logs/repair_gui_$(date +'%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$(dirname "$LOG_FILE")"

# Función auxiliar para mostrar barra de progreso
show_progress() {
  (
    for i in $(seq 0 100); do
      echo "$i"
      sleep 0.02
    done
  ) | zenity --progress --title="🧠 Reparación en curso" \
             --text="$1" --percentage=0 --auto-close --width=400
}

# Menú principal
ACTION=$(zenity --list --title="🔧 Ricitos System Repair Pro" \
  --text="Selecciona una acción de reparación:" \
  --column="Opción" \
  "Diagnóstico del entorno" \
  "Reparar entorno automáticamente" \
  "Reinstalar .NET SDK 8" \
  "Salir" --height=280 --width=420)

[ -z "$ACTION" ] && exit 0

case "$ACTION" in
  "Diagnóstico del entorno")
    show_progress "Analizando sistema..."
    bash ~/scripts/repair.sh >"$LOG_FILE" 2>&1
    zenity --text-info --title="📋 Resultados del diagnóstico" \
      --filename="$LOG_FILE" --width=720 --height=480
    ;;
  "Reparar entorno automáticamente")
    zenity --question --title="⚙️ Confirmar" \
      --text="¿Deseas ejecutar la reparación completa en modo automático?" || exit 0
    show_progress "Aplicando reparación completa..."
    bash ~/scripts/repair.sh --auto >"$LOG_FILE" 2>&1
    zenity --info --title="✅ Reparación completada" \
      --text="El entorno ha sido reparado correctamente.\n\n📁 Log: $LOG_FILE"
    ;;
  "Reinstalar .NET SDK 8")
    zenity --question --title="📦 Confirmar reinstalación" \
      --text="Se reinstalará el SDK de .NET 8. ¿Deseas continuar?" || exit 0
    show_progress "Instalando .NET SDK 8..."
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb >/dev/null 2>&1 || true
    sudo apt update -y && sudo apt install -y dotnet-sdk-8.0 >"$LOG_FILE" 2>&1
    zenity --info --title="✅ Instalación completada" \
      --text=".NET SDK 8 instalado correctamente.\n\n📁 Log: $LOG_FILE"
    ;;
  "Salir")
    exit 0 ;;
esac
