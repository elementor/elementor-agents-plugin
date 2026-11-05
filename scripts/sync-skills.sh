#!/usr/bin/env bash
# Copy canonical skills from packages/ into each platform plugin folder.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/packages/elementor-skills"
DEST="$ROOT/plugins/elementor/skills"

[ -d "$SRC" ] || { echo "Missing $SRC"; exit 1; }

rm -rf "$DEST"
mkdir -p "$DEST"
for dir in "$SRC"/*/; do
	[ -f "${dir}SKILL.md" ] || continue
	name="$(basename "$dir")"
	cp -R "$SRC/$name" "$DEST/$name"
done
echo "Synced skills: $SRC -> $DEST"
