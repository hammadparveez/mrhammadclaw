#!/usr/bin/env bash
set -euo pipefail

cd /repo

export MRHAMMADCLAW_STATE_DIR="/tmp/mrhammadclaw-test"
export MRHAMMADCLAW_CONFIG_PATH="${MRHAMMADCLAW_STATE_DIR}/mrhammadclaw.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${MRHAMMADCLAW_STATE_DIR}/credentials"
mkdir -p "${MRHAMMADCLAW_STATE_DIR}/agents/main/sessions"
echo '{}' >"${MRHAMMADCLAW_CONFIG_PATH}"
echo 'creds' >"${MRHAMMADCLAW_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${MRHAMMADCLAW_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm mrhammadclaw reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${MRHAMMADCLAW_CONFIG_PATH}"
test ! -d "${MRHAMMADCLAW_STATE_DIR}/credentials"
test ! -d "${MRHAMMADCLAW_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${MRHAMMADCLAW_STATE_DIR}/credentials"
echo '{}' >"${MRHAMMADCLAW_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm mrhammadclaw uninstall --state --yes --non-interactive

test ! -d "${MRHAMMADCLAW_STATE_DIR}"

echo "OK"
