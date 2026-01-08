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
    # Non-loopback binds require auth.
    # To support "deploy first, add env vars later", we generate a token if none is provided.
    if [ -z "${CLAWDBOT_GATEWAY_TOKEN:-}" ]; then
      token_file="/root/.clawdbot/gateway.token"
      mkdir -p /root/.clawdbot
      if [ -f "$token_file" ] && [ -s "$token_file" ]; then
        CLAWDBOT_GATEWAY_TOKEN="$(cat "$token_file" | tr -d '\n' | tr -d '\r')"
      else
        CLAWDBOT_GATEWAY_TOKEN="$(openssl rand -hex 24)"
        umask 077
        printf "%s\n" "$CLAWDBOT_GATEWAY_TOKEN" > "$token_file"
        echo "INFO: CLAWDBOT_GATEWAY_TOKEN was not set; generated one and saved to $token_file" >&2
        echo "INFO: Paste this token into the Control UI to avoid 1008 unauthorized: $CLAWDBOT_GATEWAY_TOKEN" >&2
      fi
    fi
    set -- "$@" --token "$CLAWDBOT_GATEWAY_TOKEN"
    ;;
esac

exec "$@"


