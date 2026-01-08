## hyperlift-clawdbot

This repo is a minimal, copy/paste-friendly way to run **Clawdbot Gateway** on **Starlight Hyperlift**.

### What you get

- A single `Dockerfile` image that starts `clawdbot gateway`
- A repo-root `clawdbot.json` baked into the image (edit + rebuild to change defaults)
- Control UI served from the same port as the gateway websocket (when assets are present) per [Clawdbot Web docs](https://docs.clawd.bot/web)

### Hyperlift (tutorial)

1) **Build and push** this image to wherever Hyperlift pulls images from.

2) **Create a Hyperlift service** using that image and set these env vars:

- **`PORT`**: Hyperlift injects this (we default to `8080` if it’s missing)
- **`CLAWDBOT_GATEWAY_TOKEN`**: **required** (set a strong value; you’ll paste it into the Control UI)

3) **Persist state**: make sure your Hyperlift deployment persists `/root/.clawdbot` (this is where sessions/providers end up).

4) **Open the Control UI** at `http://<your-hyperlift-url>/` and set your token:
- The Control UI stores the token in browser storage and uses it to connect to the gateway websocket.
- If you see “disconnected (1008): unauthorized”, the UI doesn’t have the right token yet.

### Local run (optional, via Docker Compose)

```bash
# Copy env.example → .env if you want (or export vars inline).
# Optional: pin version for reproducible builds:
#   CLAWDBOT_VERSION=1.2.3 docker compose up --build
PORT=8080 \
CLAWDBOT_GATEWAY_TOKEN=change-me \
docker compose up --build
```

