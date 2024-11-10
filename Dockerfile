FROM oven/bun:1.1.34@sha256:e2c0b11e277f0285e089ffb77ad831faeec2833b9c4b04d6d317f054e587ef4e AS base
WORKDIR /app
COPY package.json bun.lockb ./

FROM base AS prod-deps
RUN bun install --production --frozen-lockfile

FROM base AS build-deps
RUN bun install --frozen-lockfile

FROM build-deps AS build
COPY . .
RUN bun run build

FROM oven/bun:1.1.34-alpine@sha256:490d28250f51bf30fd88c3277f43c2c2bd721599d9ae373458c487d27bcb10f3 AS runtime
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD ["bun", "run", "./dist/server/entry.mjs"]