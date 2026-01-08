## hyperlift-clawdbot

This repo is a **ready-to-fork template** for running **Clawdbot Gateway** on **Starlight Hyperlift** with sane defaults.
Fork it, customize `clawdbot.json` for your needs, and use it as the source for your Hyperlift service.

### What you get

- A single `Dockerfile` image that starts `clawdbot gateway`
- A repo-root `clawdbot.json` baked into the image (edit + rebuild to change defaults)
- Control UI served from the same port as the gateway websocket (when assets are present) per [Clawdbot Web docs](https://docs.clawd.bot/web)

### Hyperlift (tutorial)

1) **Create a Hyperlift service** from your fork and set these env vars:

- **`CLAWDBOT_GATEWAY_TOKEN`** (recommended): set a strong value; you’ll paste it into the Control UI  
- **`OPENAI_API_KEY`** (recommended): set this if you want the **example model configured in `clawdbot.json`** (`openai/gpt-5-mini`) to work.

3) **Persist state**: make sure your Hyperlift deployment persists `/root/.clawdbot` (this is where sessions/providers end up).
   - If you rely on the auto-generated token and you **don’t** persist this directory, the token will change on redeploy.

4) **Open the Control UI** at `http://<your-hyperlift-url>/` and set your token:
- The Control UI stores the token in browser storage and uses it to connect to the gateway websocket.
- If you see “disconnected (1008): unauthorized”, the UI doesn’t have the right token yet.

