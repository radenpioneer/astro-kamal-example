FROM oven/bun:1.1.38@sha256:5148f6742ac31fac28e6eab391ab1f11f6dfc0c8512c7a3679b374ec470f5982 AS base
WORKDIR /app
COPY package.json bun.lockb ./

FROM base AS prod-deps
RUN bun install --production --frozen-lockfile

FROM base AS build-deps
RUN bun install --frozen-lockfile

FROM build-deps AS build
COPY . .
RUN bun run build

FROM oven/bun:1.1.38-alpine@sha256:c1cc397e0be452c54f37cbcdfaa747eff93c993723af7d91658764d0fdfe5873 AS runtime
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD ["bun", "run", "./dist/server/entry.mjs"]