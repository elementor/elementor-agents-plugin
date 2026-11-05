#!/usr/bin/env bash
# Checks that the plugin's skills stay short and describe the approach, not
# implementation details that change between Elementor versions.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$ROOT/packages/elementor-skills"
PLUGIN_DIR="$ROOT/plugins/elementor"
EXPECTED_SKILLS="connect-site figma-to-elementor html-to-elementor plan-site"
MAX_SKILL_LINES=70
MAX_DESCRIPTION_CHARS=1024

# Tool names, widget types, resource URIs, payload fields, and version numbers.
IMPLEMENTATION_PATTERN='elementor-[a-z]+-[a-z]+|\be-(div-block|flexbox|grid|heading|paragraph|button|image|svg|tabs?|tab-content|accordion|form[a-z-]*|list|divider|youtube|self-hosted-video)\b|elementor://|resolved_xml|element_config|configuration-id|dry_run|build-composition|manage-elements|\bv[1-9][0-9]*\b|\b[0-9]+\.[0-9]+(\.[0-9]+)?\b'

failures=0
fail() {
	echo "FAIL: $1"
	failures=$((failures + 1))
}

actual_skills="$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
[ "$actual_skills" = "$EXPECTED_SKILLS" ] || fail "skills are '$actual_skills', expected '$EXPECTED_SKILLS'"

[ -d "$PLUGIN_DIR/commands" ] && fail "commands/ should be skills"
[ -d "$SKILLS_DIR" ] || fail "missing packages/elementor-skills (canonical skills)"

for skill_dir in "$SKILLS_DIR"/*/; do
	skill="$(basename "$skill_dir")"
	skill_file="$skill_dir/SKILL.md"

	[ -f "$skill_file" ] || { fail "$skill has no SKILL.md"; continue; }
	[ -z "$(ls -A "$skill_dir" | grep -v '^SKILL.md$')" ] || fail "$skill has files besides SKILL.md"

	lines="$(wc -l < "$skill_file" | tr -d ' ')"
	[ "$lines" -le "$MAX_SKILL_LINES" ] || fail "$skill is $lines lines (max $MAX_SKILL_LINES)"

	[ "$(sed -n 1p "$skill_file")" = "---" ] || fail "$skill has no frontmatter"
	name="$(sed -n 's/^name: //p' "$skill_file" | head -1)"
	[ "$name" = "$skill" ] || fail "$skill frontmatter name is '$name'"
	description="$(sed -n 's/^description: //p' "$skill_file" | head -1)"
	[ -n "$description" ] || fail "$skill has no description"
	[ "${#description}" -le "$MAX_DESCRIPTION_CHARS" ] || fail "$skill description is ${#description} chars"

	matches="$(grep -nEo "$IMPLEMENTATION_PATTERN" "$skill_file" | head -5 | tr '\n' ' ')"
	[ -z "$matches" ] || fail "$skill mentions implementation details: $matches"
done

if [ "$failures" -gt 0 ]; then
	echo "$failures check(s) failed"
	exit 1
fi
echo "All skill checks passed"
