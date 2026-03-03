---
summary: "CLI reference for `mrhammadclaw daemon` (legacy alias for gateway service management)"
read_when:
  - You still use `mrhammadclaw daemon ...` in scripts
  - You need service lifecycle commands (install/start/stop/restart/status)
title: "daemon"
---

# `mrhammadclaw daemon`

Legacy alias for Gateway service management commands.

`mrhammadclaw daemon ...` maps to the same service control surface as `mrhammadclaw gateway ...` service commands.

## Usage

```bash
mrhammadclaw daemon status
mrhammadclaw daemon install
mrhammadclaw daemon start
mrhammadclaw daemon stop
mrhammadclaw daemon restart
mrhammadclaw daemon uninstall
```

## Subcommands

- `status`: show service install state and probe Gateway health
- `install`: install service (`launchd`/`systemd`/`schtasks`)
- `uninstall`: remove service
- `start`: start service
- `stop`: stop service
- `restart`: restart service

## Common options

- `status`: `--url`, `--token`, `--password`, `--timeout`, `--no-probe`, `--deep`, `--json`
- `install`: `--port`, `--runtime <node|bun>`, `--token`, `--force`, `--json`
- lifecycle (`uninstall|start|stop|restart`): `--json`

## Prefer

Use [`mrhammadclaw gateway`](/cli/gateway) for current docs and examples.
