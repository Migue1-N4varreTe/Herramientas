#!/bin/bash
# ────────────────────────────────────────────────
# ⏪ Command Core v4.2 – Rollback System
# Permite revertir a un commit anterior o snapshot.

echo "🔍 Available rollback points:"
git log --oneline -n 5
read -p "Enter commit hash to rollback to: " COMMIT
git checkout "$COMMIT"
echo "✅ Rolled back to $COMMIT"
