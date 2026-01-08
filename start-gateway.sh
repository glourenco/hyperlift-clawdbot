#!/bin/sh
set -eu

PORT="${PORT:-8080}"

set -- clawdbot gateway --port "$PORT"

# For Hyperlift/container use we want a host-reachable bind by default.
# You can override via CLAWDBOT_GATEWAY_BIND if needed (e.g. loopback, tailnet, auto).
CLAWDBOT_GATEWAY_BIND="${CLAWDBOT_GATEWAY_BIND:-lan}"
set -- "$@" --bind "$CLAWDBOT_GATEWAY_BIND"

case "$CLAWDBOT_GATEWAY_BIND" in
  loopback)
    # No token required for loopback binds.
    ;;
  *)
    # Non-loopback binds require auth. Fail fast to avoid confusing 1008 unauthorized loops.
    if [ -z "${CLAWDBOT_GATEWAY_TOKEN:-}" ]; then
      echo "ERROR: CLAWDBOT_GATEWAY_TOKEN is required when CLAWDBOT_GATEWAY_BIND is not 'loopback'." >&2
      echo "Set CLAWDBOT_GATEWAY_TOKEN (and paste it into the Control UI) or set CLAWDBOT_GATEWAY_BIND=loopback." >&2
      exit 2
    fi
    set -- "$@" --token "$CLAWDBOT_GATEWAY_TOKEN"
    ;;
esac

exec "$@"


