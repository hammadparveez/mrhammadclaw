---
summary: "Uninstall MrHammadClaw completely (CLI, service, state, workspace)"
read_when:
  - You want to remove MrHammadClaw from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `mrhammadclaw` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
mrhammadclaw uninstall
```

Non-interactive (automation / npx):

```bash
mrhammadclaw uninstall --all --yes --non-interactive
npx -y mrhammadclaw uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
mrhammadclaw gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
mrhammadclaw gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${MRHAMMADCLAW_STATE_DIR:-$HOME/.mrhammadclaw}"
```

If you set `MRHAMMADCLAW_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.mrhammadclaw/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g mrhammadclaw
pnpm remove -g mrhammadclaw
bun remove -g mrhammadclaw
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/MrHammadClaw.app
```

Notes:

- If you used profiles (`--profile` / `MRHAMMADCLAW_PROFILE`), repeat step 3 for each state dir (defaults are `~/.mrhammadclaw-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `mrhammadclaw` is missing.

### macOS (launchd)

Default label is `ai.mrhammadclaw.gateway` (or `ai.mrhammadclaw.<profile>`; legacy `com.mrhammadclaw.*` may still exist):

```bash
launchctl bootout gui/$UID/ai.mrhammadclaw.gateway
rm -f ~/Library/LaunchAgents/ai.mrhammadclaw.gateway.plist
```

If you used a profile, replace the label and plist name with `ai.mrhammadclaw.<profile>`. Remove any legacy `com.mrhammadclaw.*` plists if present.

### Linux (systemd user unit)

Default unit name is `mrhammadclaw-gateway.service` (or `mrhammadclaw-gateway-<profile>.service`):

```bash
systemctl --user disable --now mrhammadclaw-gateway.service
rm -f ~/.config/systemd/user/mrhammadclaw-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `MrHammadClaw Gateway` (or `MrHammadClaw Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "MrHammadClaw Gateway"
Remove-Item -Force "$env:USERPROFILE\.mrhammadclaw\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.mrhammadclaw-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://mrhammadclaw.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g mrhammadclaw@latest`.
Remove it with `npm rm -g mrhammadclaw` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `mrhammadclaw ...` / `bun run mrhammadclaw ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
