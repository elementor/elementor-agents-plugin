# Elementor for Claude

Plan your Elementor website and build native, editable Elementor pages with Claude. Claude works on your WordPress site through the **Elementor MCP server on that site**. This package adds **skills** only; you connect MCP once in your agent host (see below).

## Requirements

- WordPress with up-to-date Elementor, and MCP turned on under **Elementor > Elementor MCP**.
- A connection from your agent to `https://your-site.com/wp-json/elementor/mcp` (see **Connect your site**).
- For Figma workflows: a Figma MCP server connected in the same agent session.

## Install

In claude.ai, Claude Desktop, or Cowork: **Customize > Plugins**. In Claude Code:

```shell
/plugin marketplace add elementor/elementor-agents-plugin
/plugin install elementor@elementor
```

## Connect your site

This plugin **does not** register MCP for you. Start on your site:

**Elementor → Elementor MCP** in wp-admin (`/wp-admin/admin.php?page=elementor-mcp`).

On that page: turn MCP on, copy the server URL, and follow the **connection steps shown there** for your agent (including any Check connection control). Do not use generic WordPress Application Password screens unless the Elementor MCP page sends you there.

Use the install snippet or steps the page shows for your agent (including local config files when the page names them). If a password was shared in chat by mistake, revoke it on the MCP page and create a new one.

Ask Claude to **connect my Elementor site** to walk through it with the `connect-site` skill. You need a WordPress site with Elementor first.

## Skills

| Skill | What it does |
| --- | --- |
| `connect-site` | Connect MCP, check the connection, troubleshoot auth and reachability |
| `plan-site` | Plan a site or redesign, then build drafts after you approve |
| `html-to-elementor` | Rebuild HTML/CSS or a page URL as native Elementor elements |
| `figma-to-elementor` | Build from Figma frames using your design tokens |

## Example prompts

- "Connect my Elementor site: https://example.elementor.cloud"
- "Plan a bakery website with home, menu, about, and contact."
- "Convert this HTML into native Elementor using my design system."
- "Is my Elementor site connected?"

## Data and privacy

Traffic goes from your agent provider to **your** site. Elementor does not proxy it. The connected WordPress user’s permissions apply; builds stay draft unless you ask to publish. Revoke the Application Password in wp-admin and remove the MCP entry in your agent settings.

[Elementor privacy policy](https://elementor.com/terms/privacy/) · [Help](https://elementor.com/help/) · [Support](https://elementor.com/support/)

## Icon

Elementor logo symbol from [elementor.com](https://elementor.com) (`assets/icon.svg`).

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
