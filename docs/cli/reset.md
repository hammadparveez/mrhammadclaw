---
summary: "CLI reference for `mrhammadclaw reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `mrhammadclaw reset`

Reset local config/state (keeps the CLI installed).

```bash
mrhammadclaw reset
mrhammadclaw reset --dry-run
mrhammadclaw reset --scope config+creds+sessions --yes --non-interactive
```
