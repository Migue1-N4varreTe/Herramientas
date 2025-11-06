#!/bin/bash
# ==========================================================
# Script: user_audit.sh
# Descripción: Audita usuarios y grupos activos del sistema.
# Versión: 4.2
# Autor: Command Core System
# Fecha: $(date +"%Y-%m-%d")
# ==========================================================

set -e
echo "👥 Auditando usuarios del sistema..."
awk -F: '{ print $1 }' /etc/passwd | sort
echo "📦 Grupos activos:"
cut -d: -f1 /etc/group | sort
echo "✅ Auditoría completada."

