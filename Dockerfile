# Runflare-compatible root Dockerfile for Andarama (service 87975)
# Build context: repository root. Listens on PORT (default 3000) for Runflare mapping 80->3000.

# ---------- build ----------
FROM node:22-bookworm-slim AS build
RUN corepack enable
WORKDIR /app
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY tooling ./tooling
COPY packages ./packages
COPY apps ./apps
COPY deploy ./deploy
# Use locked versions verified in CI
RUN pnpm install --frozen-lockfile
RUN pnpm build:packages
# Build docs and web before Studio assets are collected
RUN pnpm --filter @andarama/docs build
RUN pnpm --filter @andarama/web build
RUN pnpm --filter @andarama/studio build
RUN pnpm --filter @andarama/api build:node

# ---------- runtime deps (native/externals) ----------
FROM node:22-bookworm-slim AS deps
WORKDIR /deps
RUN npm install --omit=dev better-sqlite3@13 sharp@0.33 ws@8 nodemailer@6

# ---------- runtime ----------
FROM node:22-bookworm-slim
ENV NODE_ENV=production \
    DATA_DIR=/data/andarama \
    PORT=3000 \
    ASSETS_DIR=/app/assets
WORKDIR /app
COPY --from=build /app/apps/api/dist-node/node.js ./server.js
COPY --from=build /app/apps/studio/dist-root ./assets
COPY --from=build /app/packages/db/migrations ./migrations
COPY --from=deps /deps/node_modules ./node_modules
VOLUME /data
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s CMD node -e "fetch('http://localhost:3000/api/v1/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["node", "server.js"]
