FROM node:22-bookworm-slim

# Minimal init to handle SIGTERM correctly on Hyperlift
RUN apt-get update \
  && apt-get install -y --no-install-recommends tini ca-certificates git openssl \
  && rm -rf /var/lib/apt/lists/*

# Install Clawdbot CLI (docs recommend global install via npm/pnpm)
# Allow pinning for reproducible builds: --build-arg CLAWDBOT_VERSION=1.2.3
ARG CLAWDBOT_VERSION=latest
RUN npm install -g "clawdbot@${CLAWDBOT_VERSION}" \
  && npm cache clean --force

# Use Clawdbot defaults (typically ~/.clawdbot under the image's HOME)
ENV NODE_ENV=production

# Default config baked into the image (can be overridden by a runtime bind-mount)
RUN mkdir -p /root/.clawdbot
COPY clawdbot.json /root/.clawdbot/clawdbot.json

# Simple entrypoint wrapper to handle optional env vars cleanly
COPY start-gateway.sh /usr/local/bin/start-gateway
RUN chmod +x /usr/local/bin/start-gateway

# Hyperlift default app port is 8080 (it can also inject $PORT)
EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/start-gateway"]

