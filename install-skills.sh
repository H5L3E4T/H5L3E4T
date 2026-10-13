#!/usr/bin/env bash
# Installe les skills HyperFrames du dépôt dans ~/.claude/skills (global à ta machine).
# Usage :
#   ./install-skills.sh            # copie seulement les skills absents
#   ./install-skills.sh --force    # écrase les skills déjà présents
set -euo pipefail

FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/.agents/skills"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

if [ ! -d "$SRC" ]; then
  echo "Erreur : $SRC introuvable. Lance ce script depuis le dépôt H5L3E4T." >&2
  exit 1
fi

mkdir -p "$DEST"
copied=0
skipped=0

for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  if [ -e "$DEST/$name" ] && [ "$FORCE" -eq 0 ]; then
    echo "déjà présent : $name"
    skipped=$((skipped + 1))
    continue
  fi
  rm -rf "$DEST/$name"
  cp -rL "$dir" "$DEST/$name"
  echo "installé     : $name"
  copied=$((copied + 1))
done

echo
echo "Terminé : $copied installé(s), $skipped déjà présent(s) → $DEST"
echo "Redémarre Claude Code pour charger les nouveaux skills, puis tape /hyperframes."
echo "Prérequis pour le rendu vidéo : node et ffmpeg (npx hyperframes doctor pour vérifier)."
