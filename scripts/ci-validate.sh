#!/usr/bin/env bash
# CI and local gate: sync canonical skills into the plugin bundle, then check + validate.
# Edit skills only under packages/elementor-skills/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_CODE_PKG="${CLAUDE_CODE_PKG:-@anthropic-ai/claude-code@2.1.308}"
PLUGIN="$ROOT/plugins/elementor"

"$ROOT/scripts/sync-skills.sh"

# The directory installs plugins/elementor as committed, so the committed skills must match packages/.
if [ -n "${CI:-}" ] && drift="$(git -C "$ROOT" status --porcelain -- plugins/elementor/skills)" && [ -n "$drift" ]; then
	echo "FAIL: plugins/elementor/skills/ is out of sync with packages/elementor-skills/. Run ./scripts/sync-skills.sh and commit the result."
	echo "$drift"
	exit 1
fi

"$ROOT/scripts/check-skills.sh"

run_claude() {
	if [ -n "${CLAUDE_BIN:-}" ]; then
		"$CLAUDE_BIN" "$@"
		return
	fi
	if command -v claude >/dev/null 2>&1; then
		claude "$@"
		return
	fi
	npx --yes "$CLAUDE_CODE_PKG" "$@"
}

run_claude plugin validate "$ROOT" --strict
run_claude plugin validate "$PLUGIN" --strict

echo "CI validate passed (skills synced from packages/elementor-skills)"
