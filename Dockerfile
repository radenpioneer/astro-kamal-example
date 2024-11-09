FROM oven/bun:1.1.34 AS base
WORKDIR /app
COPY package.json package-lock.json ./

FROM base AS prod-deps
RUN bun install --production --frozen-lockfile

FROM base AS build-deps
RUN bun install --frozen-lockfile

FROM build-deps AS build
COPY . .
RUN bun run build

FROM oven/bun:1.1.34-slim AS runtime
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
ENV HOST=0.0.0.0
ENV PORT=80
EXPOSE 80
CMD bun run ./dist/server/entry.mjs