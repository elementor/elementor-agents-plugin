# Build and release

This repo is meant to grow into **one place for Elementor agent integrations**: shared skill text, plus thin packaging per platform (Claude plugin today; Codex and others later).

## Layout

| Path | Role |
| --- | --- |
| [`packages/elementor-skills/`](../packages/elementor-skills/) | **Canonical skills.** Edit only here. |
| [`plugins/elementor/`](../plugins/elementor/) | Client plugin shell: manifest, README, LICENSE, assets (icon). Skills-only (no bundled MCP). `skills/` is **generated** from `packages/` and committed by CI. |
| [`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json) | Claude marketplace that points at `plugins/elementor`. |
| [`dist/`](../dist/) | Build output (gitignored). |
| [`scripts/build.sh`](../scripts/build.sh) | Sync skills, run checks, produce artifacts. |

The icon is the approved Elementor mark from [elementor.com](https://elementor.com) (`logo-symbol-1.svg`), referenced in `plugin.json` as `./assets/icon.svg` for the Anthropic directory listing.

## Build commands

From the repo root:

```shell
chmod +x scripts/*.sh   # once

./scripts/build.sh              # Claude zip (default)
./scripts/build.sh claude       # dist/elementor-<version>.zip
./scripts/build.sh codex        # dist/codex/elementor-<version>/skills/
./scripts/build.sh all          # both
```

**Dev flow:** edit only `packages/elementor-skills/`. Don't hand-edit `plugins/elementor/skills/`.

**Why the generated skills are committed:** the directory and marketplace installs read `plugins/elementor/` from the tracked branch as committed, with no build step. If `skills/` isn't committed, the published plugin has no skills, and `claude plugin validate` still passes.

**CI** (`.github/workflows/validate.yml`) and local gate **`scripts/ci-validate.sh`**:

1. **`sync-skills.sh`** — copies skill folders → `plugins/elementor/skills/`. On PRs from this repo, CI commits the result to the PR branch (`chore: sync generated skills`). In CI, `ci-validate.sh` fails if the committed skills differ from `packages/`.
2. **`check-skills.sh`** — length, frontmatter, no version-specific tool/widget names.
3. **`claude plugin validate`** — marketplace + plugin, `--strict` (uses `claude` on PATH, or `npx @anthropic-ai/claude-code@2.1.308`).

**Release build** (`build.sh`) runs `ci-validate.sh` for the Claude target, then packages:

4. **Package** — zip the Claude plugin folder, or copy skills for Codex.

Version comes from `plugins/elementor/.claude-plugin/plugin.json` (`version` field). Output names include that version, e.g. `dist/elementor-1.0.0.zip`.

## Local testing (Claude)

1. Run `./scripts/build.sh claude`.
2. In Claude Desktop or claude.ai: **Customize > Plugins > Upload plugin** → choose `dist/elementor-<version>.zip`.
3. Connect MCP using the `connect-site` skill (Application Password in the host UI).
4. Or load the plugin locally: `./scripts/sync-skills.sh` then `claude --plugin-dir ./plugins/elementor`, then add MCP per the skill.

## Release builds

Every merge to `master` runs `.github/workflows/release.yml`: it builds the Claude zip and creates a GitHub release tagged `v<version>-build.<N>`, where `<N>` counts up per run, with the zip attached and notes generated from the merged PRs. These releases are for download and file upload; the directory still reads the tracked branch.

## How updates work

### Skills only (no manifest change)

1. Change files under `packages/elementor-skills/`.
2. Run `./scripts/check-skills.sh` (or full `./scripts/build.sh`).
3. For local zip testing: upload a new zip from `dist/`.
4. For the **Anthropic directory**: bump `version` in `plugin.json` (and marketplace entry if you keep them in sync), push to the tracked GitHub branch; the portal picks up commits on the branch you configured when you [update a published plugin](https://claude.com/docs/connectors/building/after-publishing).

### Plugin metadata (URLs, description, icon)

Edit `plugins/elementor/.claude-plugin/plugin.json`, README, or `assets/`, bump `version`, rebuild, push. Directory listing fields (`icon`, `privacyPolicyUrl`, etc.) are read from the manifest at submission/update time.

### MCP vs this repo

MCP is served by **Elementor on the user’s site**. This repo publishes a **skills-only** plugin; connection is documented in `connect-site`, not bundled as `mcpServers`.

## Codex today

`./scripts/build.sh codex` writes the same four skills into `dist/codex/elementor-<version>/skills/`. Install by copying or symlinking into `~/.codex/skills/`. Codex uses the same `SKILL.md` frontmatter shape; no `.mcp.json` in that export yet (connection is still via Codex MCP config).

## Cursor and other platforms (planned)

Target shape for this repo:

```
packages/
  elementor-skills/          # shared
plugins/
  claude/elementor/          # rename when a second plugin lands
  codex/...                  # optional thin wrappers
  cursor/...                 # Cursor plugin marketplace layout
scripts/
  build.sh claude|codex|cursor|all
```

Cursor’s Elementor plugin cache today mirrors the Claude layout (skills + commands). A `cursor` build target would zip or copy the same skills into that layout. **Shared build rules** (`check-skills.sh`) stay platform-agnostic; only packaging and connection docs differ per platform.

## Adding another plugin later

1. New folder under `packages/<name>-skills/` or shared skills reused across products.
2. New `plugins/<platform>/<name>/` with its own manifest.
3. Extend `build.sh` with a target that syncs the right skill set and validates the right manifest.
