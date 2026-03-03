---
summary: "CLI reference for `mrhammadclaw browser` (profiles, tabs, actions, extension relay)"
read_when:
  - You use `mrhammadclaw browser` and want examples for common tasks
  - You want to control a browser running on another machine via a node host
  - You want to use the Chrome extension relay (attach/detach via toolbar button)
title: "browser"
---

# `mrhammadclaw browser`

Manage MrHammadClaw’s browser control server and run browser actions (tabs, snapshots, screenshots, navigation, clicks, typing).

Related:

- Browser tool + API: [Browser tool](/tools/browser)
- Chrome extension relay: [Chrome extension](/tools/chrome-extension)

## Common flags

- `--url <gatewayWsUrl>`: Gateway WebSocket URL (defaults to config).
- `--token <token>`: Gateway token (if required).
- `--timeout <ms>`: request timeout (ms).
- `--browser-profile <name>`: choose a browser profile (default from config).
- `--json`: machine-readable output (where supported).

## Quick start (local)

```bash
mrhammadclaw browser --browser-profile chrome tabs
mrhammadclaw browser --browser-profile mrhammadclaw start
mrhammadclaw browser --browser-profile mrhammadclaw open https://example.com
mrhammadclaw browser --browser-profile mrhammadclaw snapshot
```

## Profiles

Profiles are named browser routing configs. In practice:

- `mrhammadclaw`: launches/attaches to a dedicated MrHammadClaw-managed Chrome instance (isolated user data dir).
- `chrome`: controls your existing Chrome tab(s) via the Chrome extension relay.

```bash
mrhammadclaw browser profiles
mrhammadclaw browser create-profile --name work --color "#FF5A36"
mrhammadclaw browser delete-profile --name work
```

Use a specific profile:

```bash
mrhammadclaw browser --browser-profile work tabs
```

## Tabs

```bash
mrhammadclaw browser tabs
mrhammadclaw browser open https://docs.mrhammadclaw.ai
mrhammadclaw browser focus <targetId>
mrhammadclaw browser close <targetId>
```

## Snapshot / screenshot / actions

Snapshot:

```bash
mrhammadclaw browser snapshot
```

Screenshot:

```bash
mrhammadclaw browser screenshot
```

Navigate/click/type (ref-based UI automation):

```bash
mrhammadclaw browser navigate https://example.com
mrhammadclaw browser click <ref>
mrhammadclaw browser type <ref> "hello"
```

## Chrome extension relay (attach via toolbar button)

This mode lets the agent control an existing Chrome tab that you attach manually (it does not auto-attach).

Install the unpacked extension to a stable path:

```bash
mrhammadclaw browser extension install
mrhammadclaw browser extension path
```

Then Chrome → `chrome://extensions` → enable “Developer mode” → “Load unpacked” → select the printed folder.

Full guide: [Chrome extension](/tools/chrome-extension)

## Remote browser control (node host proxy)

If the Gateway runs on a different machine than the browser, run a **node host** on the machine that has Chrome/Brave/Edge/Chromium. The Gateway will proxy browser actions to that node (no separate browser control server required).

Use `gateway.nodes.browser.mode` to control auto-routing and `gateway.nodes.browser.node` to pin a specific node if multiple are connected.

Security + remote setup: [Browser tool](/tools/browser), [Remote access](/gateway/remote), [Tailscale](/gateway/tailscale), [Security](/gateway/security)
