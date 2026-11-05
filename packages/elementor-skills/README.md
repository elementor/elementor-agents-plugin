# Elementor skills (canonical)

Edit skill content **only in this folder**. On each PR, CI copies these skills into `plugins/elementor/skills/` and commits the result to the PR branch, because the plugin directory installs that folder as committed. Do not edit the generated tree by hand.

Skills:

- `connect-site` — MCP connection via **Elementor → Elementor MCP** in wp-admin (no bundled connector)
- `plan-site` — site plan and draft setup
- `html-to-elementor` — HTML/CSS to native Elementor
- `figma-to-elementor` — Figma frames to Elementor (needs Figma MCP)

Keep each `SKILL.md` short and **approach-level**: no Elementor tool names, widget types, or prop shapes (they change between site versions). Tell the agent to read the connected site’s own instructions and schemas.
