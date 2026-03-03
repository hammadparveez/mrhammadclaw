---
summary: "CLI reference for `mrhammadclaw devices` (device pairing + token rotation/revocation)"
read_when:
  - You are approving device pairing requests
  - You need to rotate or revoke device tokens
title: "devices"
---

# `mrhammadclaw devices`

Manage device pairing requests and device-scoped tokens.

## Commands

### `mrhammadclaw devices list`

List pending pairing requests and paired devices.

```
mrhammadclaw devices list
mrhammadclaw devices list --json
```

### `mrhammadclaw devices remove <deviceId>`

Remove one paired device entry.

```
mrhammadclaw devices remove <deviceId>
mrhammadclaw devices remove <deviceId> --json
```

### `mrhammadclaw devices clear --yes [--pending]`

Clear paired devices in bulk.

```
mrhammadclaw devices clear --yes
mrhammadclaw devices clear --yes --pending
mrhammadclaw devices clear --yes --pending --json
```

### `mrhammadclaw devices approve [requestId] [--latest]`

Approve a pending device pairing request. If `requestId` is omitted, MrHammadClaw
automatically approves the most recent pending request.

```
mrhammadclaw devices approve
mrhammadclaw devices approve <requestId>
mrhammadclaw devices approve --latest
```

### `mrhammadclaw devices reject <requestId>`

Reject a pending device pairing request.

```
mrhammadclaw devices reject <requestId>
```

### `mrhammadclaw devices rotate --device <id> --role <role> [--scope <scope...>]`

Rotate a device token for a specific role (optionally updating scopes).

```
mrhammadclaw devices rotate --device <deviceId> --role operator --scope operator.read --scope operator.write
```

### `mrhammadclaw devices revoke --device <id> --role <role>`

Revoke a device token for a specific role.

```
mrhammadclaw devices revoke --device <deviceId> --role node
```

## Common options

- `--url <url>`: Gateway WebSocket URL (defaults to `gateway.remote.url` when configured).
- `--token <token>`: Gateway token (if required).
- `--password <password>`: Gateway password (password auth).
- `--timeout <ms>`: RPC timeout.
- `--json`: JSON output (recommended for scripting).

Note: when you set `--url`, the CLI does not fall back to config or environment credentials.
Pass `--token` or `--password` explicitly. Missing explicit credentials is an error.

## Notes

- Token rotation returns a new token (sensitive). Treat it like a secret.
- These commands require `operator.pairing` (or `operator.admin`) scope.
- `devices clear` is intentionally gated by `--yes`.
- If pairing scope is unavailable on local loopback (and no explicit `--url` is passed), list/approve can use a local pairing fallback.
