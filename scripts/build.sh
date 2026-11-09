#!/usr/bin/env bash
# Build Elementor agent packages from shared skills in packages/elementor-skills.
#
# Usage:
#   ./scripts/build.sh              # same as claude
#   ./scripts/build.sh claude       # zip for Claude (Customize > Upload plugin)
#   ./scripts/build.sh codex        # folder tree for Codex (~/.codex/skills or repo install)
#   ./scripts/build.sh all          # claude + codex
#
# Reads version from plugins/elementor/.claude-plugin/plugin.json.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$ROOT/plugins/elementor"
MANIFEST="$PLUGIN/.claude-plugin/plugin.json"
DIST="$ROOT/dist"

version() {
	node -e "console.log(require(process.argv[1]).version)" "$MANIFEST"
}

build_claude() {
	"$ROOT/scripts/ci-validate.sh"

	local ver out
	ver="$(version)"
	out="$DIST/elementor-${ver}.zip"
	mkdir -p "$DIST"
	rm -f "$out"
	links="$(find "$PLUGIN" -type l -print)"
	if [ -n "$links" ]; then
		echo "FAIL: plugins/elementor contains a symlink"
		printf '%s\n' "$links"
		exit 1
	fi
	( cd "$PLUGIN" && zip -rq -X "$out" . -x '*.DS_Store' '__MACOSX/*' )
	echo "Built $out"
	unzip -l "$out" | tail -3
}

build_codex() {
	"$ROOT/scripts/sync-skills.sh"
	"$ROOT/scripts/check-skills.sh"
	# Codex export only needs skills; skip full plugin validate unless you run ci-validate.sh

	local ver dest
	ver="$(version)"
	dest="$DIST/codex/elementor-${ver}/skills"
	rm -rf "$dest"
	mkdir -p "$dest"
	for dir in "$ROOT/packages/elementor-skills"/*/; do
		[ -f "${dir}SKILL.md" ] || continue
		name="$(basename "$dir")"
		cp -R "$ROOT/packages/elementor-skills/$name" "$dest/$name"
	done

	cat > "$DIST/codex/elementor-${ver}/README.txt" <<EOF
Elementor skills for Codex (${ver})

Install: copy the skills/ folder into your Codex skills path, e.g.
  cp -R skills/* ~/.codex/skills/

Or symlink each skill:
  ln -sf $(pwd)/skills/connect-site ~/.codex/skills/connect-site

Edit the canonical sources in the monorepo under packages/elementor-skills/.
EOF
	echo "Built $dest ($(find "$dest" -name SKILL.md | wc -l | tr -d ' ') skills)"
}

target="${1:-claude}"
case "$target" in
	claude) build_claude ;;
	codex) build_codex ;;
	all)
		build_claude
		build_codex
		;;
	*)
		echo "Unknown target: $target (use claude, codex, or all)"
		exit 1
		;;
esac
