# MrHammadClaw

<p align="center">
  <img src="docs/assets/mrhammadclaw-hero.png" alt="MrHammadClaw" width="600">
</p>

**A personal AI gateway that spawns Claude Code as a subprocess — no OAuth token extraction, no TOS violations.**

<p align="center">
  <a href="https://github.com/hammadparveez/mrhammadclaw"><img src="https://img.shields.io/github/stars/hammadparveez/mrhammadclaw?style=for-the-badge" alt="GitHub stars"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"></a>
</p>

## Why MrHammadClaw?

In January 2026, [Anthropic banned third-party tools](https://www.theregister.com/2026/02/20/anthropic_clarifies_ban_third_party_claude_access) from using OAuth tokens obtained through Claude Pro/Max/Free subscriptions. Projects like OpenClaw, OpenCode, Cline, and RooCode were affected because they extracted and reused OAuth tokens outside of Claude Code — a direct violation of Anthropic's Consumer Terms of Service.

**MrHammadClaw takes a different approach.** Instead of extracting OAuth tokens, it spawns the official Claude Code CLI as a child process. Your Claude subscription authenticates through Claude Code itself — MrHammadClaw never touches or stores your OAuth tokens.

```
Traditional approach (banned):
  App → extracts OAuth token → calls Anthropic API directly

MrHammadClaw approach (compliant):
  MrHammadClaw → spawns `claude` CLI → Claude Code handles its own auth
```

## What is it?

MrHammadClaw is a **personal AI gateway** that sits between your messaging channels and AI backends. It manages sessions, memory, cron jobs, heartbeat, and multi-channel routing — while the actual AI inference is handled by spawning CLI tools (Claude Code, OpenAI Codex, etc.) as subprocesses.

### Key Features

- **CLI-subprocess architecture** — spawns `claude` or `codex` as child processes; no token extraction
- **Multi-channel inbox** — WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Microsoft Teams, Matrix, Google Chat, and more
- **Session management** — persistent sessions with context, compaction, and per-channel isolation
- **Memory system** — builtin or vector-search-backed long-term memory
- **Cron & automation** — scheduled jobs, webhooks, heartbeat (periodic self-check)
- **Workspace & skills** — prompt injection via workspace files (AGENTS.md, SOUL.md, TOOLS.md) and a skills platform
- **Multi-agent routing** — route channels/users to isolated agents with separate workspaces
- **Voice Wake + Talk Mode** — always-on speech on macOS/iOS/Android
- **Browser control** — managed Chrome/Chromium with CDP
- **Companion apps** — macOS menu bar, iOS node, Android node

## Architecture

```
WhatsApp / Telegram / Slack / Discord / Signal / iMessage / Teams / Matrix
               |
               v
+-------------------------------+
|           Gateway             |
|       (control plane)         |
|     ws://127.0.0.1:18789      |
+---------------+---------------+
                |
     +----------+----------+
     |          |           |
  spawns     spawns      spawns
  `claude`   `codex`    (other CLI)
     |          |           |
     v          v           v
  Claude     OpenAI      Custom
  Code CLI   Codex CLI   Backend
```

The gateway manages sessions, routing, and tools. When a message arrives, it spawns the configured CLI backend as a subprocess, passes the prompt, and streams the response back to the originating channel.

### CLI Backend Configuration

MrHammadClaw supports pluggable CLI backends. The defaults are:

| Backend    | Command                          | How it authenticates                        |
| ---------- | -------------------------------- | ------------------------------------------- |
| **Claude** | `claude -p --output-format json` | Claude Code's own auth (`claude` CLI login) |
| **Codex**  | `codex exec --json`              | OpenAI Codex's own auth                     |

You can configure custom backends in your config file.

## Status

This project is a **customized fork of [OpenClaw](https://github.com/openclaw/openclaw)** (originally Clawd by Peter Steinberger). The basic implementation is complete and ready to use. Active development is ongoing.

### What works

- Gateway with WebSocket control plane
- CLI agent spawning (Claude Code, Codex)
- Session persistence and context management
- Multi-channel messaging (Telegram, WhatsApp, Slack, Discord, etc.)
- Cron jobs and heartbeat
- Workspace-based prompt injection
- Skills platform
- Memory system
- Voice Wake and Talk Mode

### What's in progress

- Extended documentation
- Additional backend integrations
- Enhanced error handling and reliability improvements

## Quick Start

**Requirements:** Node >= 22

### Install

```bash
npm install -g mrhammadclaw@latest

mrhammadclaw onboard --install-daemon
```

### From source

```bash
git clone https://github.com/hammadparveez/mrhammadclaw.git
cd mrhammadclaw

pnpm install
pnpm build

pnpm mrhammadclaw onboard --install-daemon
```

### Basic usage

```bash
# Start the gateway
mrhammadclaw gateway --port 18789 --verbose

# Send a message via the CLI
mrhammadclaw agent --message "Hello from MrHammadClaw" --thinking high

# Send to a channel
mrhammadclaw message send --to +1234567890 --message "Hello"
```

### Minimal config

Create `~/.mrhammadclaw/mrhammadclaw.json`:

```json5
{
  agent: {
    model: "anthropic/claude-opus-4-6",
  },
}
```

## Channel Setup

### Telegram

```json5
{
  channels: {
    telegram: {
      botToken: "YOUR_BOT_TOKEN",
    },
  },
}
```

### Slack

Set `SLACK_BOT_TOKEN` + `SLACK_APP_TOKEN` env vars, or configure in the config file.

### Discord

```json5
{
  channels: {
    discord: {
      token: "YOUR_BOT_TOKEN",
    },
  },
}
```

### WhatsApp

```bash
mrhammadclaw channels login  # Scans QR code to link device
```

Configure allowlist via `channels.whatsapp.allowFrom`.

### Other channels

Signal, iMessage (via BlueBubbles), Microsoft Teams, Matrix, Google Chat, Zalo, and WebChat are all supported through extensions.

## How It Differs from OpenClaw

| Aspect            | OpenClaw (original)                                 | MrHammadClaw (this fork)                                    |
| ----------------- | --------------------------------------------------- | ----------------------------------------------------------- |
| **Auth approach** | Used OAuth tokens from Claude Pro/Max subscriptions | Spawns Claude Code CLI — auth handled by Claude Code itself |
| **Anthropic TOS** | Violated (tokens used outside Claude Code)          | Compliant (uses Claude Code as intended)                    |
| **Anthropic ban** | Affected by Jan 2026 OAuth ban                      | Not affected — never extracts tokens                        |
| **Backend**       | In-process API calls                                | CLI subprocess spawning                                     |
| **Multi-backend** | Limited                                             | Claude Code + OpenAI Codex + custom backends                |

## Workspace Structure

```
~/.mrhammadclaw/
  mrhammadclaw.json   # Main config
  workspace/           # Agent workspace
    AGENTS.md          # Agent behavior/personality
    SOUL.md            # Core identity prompt
    TOOLS.md           # Tool documentation
    HEARTBEAT.md       # Heartbeat check prompt
    skills/            # Installed skills
  sessions/            # Session transcripts
  credentials/         # Channel credentials
```

## Security

- DM pairing by default — unknown senders must be approved
- Optional Docker sandboxing for non-main sessions
- All channel credentials stored locally
- No OAuth tokens are extracted or stored — Claude Code manages its own auth

Run `mrhammadclaw doctor` to check for misconfigurations.

## Development

```bash
pnpm install
pnpm build          # Type-check and build
pnpm test           # Run tests (Vitest)
pnpm check          # Lint and format check
pnpm gateway:watch  # Dev loop with auto-reload
```

## Contributing

1. Fork the repo
2. Create a feature branch (`feature/my-feature`)
3. All changes require tests
4. Submit a PR — requires 1 approving review

## Credits

This project is a fork of [OpenClaw](https://github.com/openclaw/openclaw) (originally Clawd by Peter Steinberger). Full credit to the original authors and contributors.

## License

[MIT](LICENSE)
