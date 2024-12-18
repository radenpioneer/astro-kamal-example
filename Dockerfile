FROM oven/bun:1.1.40@sha256:d3fa18119382d9c6f38b2315d76e3c4749b6e8a28772ecd543bcf0b26775b9e0 AS base
WORKDIR /app
COPY package.json bun.lockb ./

FROM base AS prod-deps
RUN bun install --production --frozen-lockfile

FROM base AS build-deps
RUN bun install --frozen-lockfile

FROM build-deps AS build
COPY . .
RUN bun run build

FROM oven/bun:1.1.40-alpine@sha256:f6c70b20b96d25b7374cb2f474030a74e78fcdbc6e37c0b3c580d2834051746f AS runtime
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD ["bun", "run", "./dist/server/entry.mjs"]