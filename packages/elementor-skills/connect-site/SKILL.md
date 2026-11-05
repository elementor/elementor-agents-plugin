---
name: connect-site
description: Guides the user to connect their Elementor WordPress site through the Elementor MCP connection page in wp-admin and the agent host's MCP settings, checks whether a connection works, and troubleshoots reachability and auth. Use when Elementor tools are missing, the user wants to connect a site, says they have no WordPress site, or connection fails with not found, unauthorized, forbidden, or sign-in registration errors.
---

# Connect an Elementor site

This plugin does **not** add an MCP server. Connection starts on the **Elementor MCP connection page** in the user's WordPress admin. That page is the source of truth: follow its instructions rather than assuming the server URL, config paths, or steps.

## No WordPress site yet

Elementor MCP runs **on the user's own WordPress site**. Without a site, there is nothing to connect.

Tell them they need WordPress with Elementor first. Options: **Elementor hosting**, **their own WordPress** with Elementor updated, or **local WordPress** (usually with a local CLI agent). Do not connect without a site.

## 1. Check whether it's already connected

If Elementor tools are available, make one cheap read call and tell the user which site answered. Stop when it works.

## 2. Elementor MCP connection page (always first)

Ask for the **domain** if needed. Send the user to the **Elementor MCP connection page**:  
`https://<domain>/wp-admin/admin.php?page=elementor-mcp`

Have them follow **that page's** steps for their agent host. Do not construct the server URL or guess connection details yourself, and do not send them to generic wp-admin screens unless the page does.

## 3. Apply what the page gives the user

The connection page may give the user a **ready-made message or config** to hand to their agent.

When the user pastes it and asks to add the server:

1. **Do it.** Apply the config exactly where and how the pasted instructions say. Preserve any other existing settings in that config.
2. Use the **credentials** from the user's paste when the page supplied them.
3. In your reply, **do not echo** passwords, tokens, or auth headers. Confirm what you changed (server name, where it was configured) and that they should restart or reload MCP.

Do not ask users to type passwords into chat for no reason. Do not bypass MCP with raw HTTP or reading site files unless the page says to.

## 4. After connecting

New chat or reload MCP tools, then repeat step 1.

## Troubleshooting

| Symptom | What to tell the user |
| --- | --- |
| Can't find the Elementor MCP connection page | Update Elementor |
| MCP server not found | Enable MCP on the connection page |
| Sign-in registration failed | Use the alternative setup steps on the **connection page** |
| Unauthorized / forbidden | Reconnect from the connection page as an administrator |
| Tools still missing | Reload MCP; use the connection page's check, if it offers one |

## Revoking access

Revoke on the **connection page**, remove the server from the agent config, and revoke any credentials the page created.
