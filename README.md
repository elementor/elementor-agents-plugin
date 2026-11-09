# Elementor for AI agents

Plan your website and build native, editable Elementor pages by chatting with your AI agent. The agent works directly on your WordPress site through the Elementor MCP server, so everything it builds stays fully editable in the Elementor editor.

## What you can do

- **Plan a site:** describe your business and get a site plan (pages, sections, design system), then let the agent build it after you approve.
- **Convert HTML or a web page:** turn HTML/CSS, a page URL, or a short list of pages into native Elementor elements.
- **Build from Figma:** turn Figma frames into Elementor pages that use your design tokens.
- **Connect and troubleshoot:** get guided through connecting your site, and fix common connection problems.

Pages are saved as drafts unless you ask to publish.

## Requirements

- A WordPress site with an up-to-date version of Elementor.
- MCP turned on in wp-admin under **Elementor → Elementor MCP**.
- For Figma workflows: a Figma MCP server connected in the same agent.

Don't have a WordPress site yet? Ask the agent and it will point you to options for getting started with Elementor.

## Install

Install the **Elementor** plugin from your agent's plugin directory or marketplace. In Claude Code:

```shell
/plugin marketplace add elementor/elementor-agents-plugin
/plugin install elementor@elementor
```

To install from a file instead, download the latest zip from [Releases](https://github.com/elementor/elementor-agents-plugin/releases/latest) and upload it in your agent's plugin settings.

## Connect your site

1. In wp-admin, open **Elementor → Elementor MCP** (`/wp-admin/admin.php?page=elementor-mcp`).
2. Turn MCP on and follow the connection steps that page shows for your agent.
3. Ask your agent: *"Connect my Elementor site"*. It walks you through the setup and checks the connection.

## Example prompts

- "Connect my Elementor site: https://example.com"
- "Plan a bakery website with home, menu, about, and contact pages."
- "Rebuild https://example.com/about as an Elementor page."
- "Convert this HTML into native Elementor using my design system."
- "Build this Figma frame as a new page."

## Privacy

Your agent talks directly to **your** site; Elementor does not proxy the traffic. The agent can only do what the connected WordPress user is allowed to do. To disconnect, revoke the credentials on the Elementor MCP page and remove the server from your agent's settings.

[Privacy policy](https://elementor.com/terms/privacy/) · [Terms](https://elementor.com/terms/)

## Help and support

- [Elementor Help Center](https://elementor.com/help/)
- [Elementor Support](https://elementor.com/support/)

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).

Contributing? See [docs/BUILD.md](docs/BUILD.md).
