FROM node:20.9.0-alpine@sha256:8e015de364a2eb2ed7c52a558e9f716dcb615560ffd132234087c10ccc1f2c63 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.9.0-alpine@sha256:8e015de364a2eb2ed7c52a558e9f716dcb615560ffd132234087c10ccc1f2c63 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.9.0-alpine@sha256:8e015de364a2eb2ed7c52a558e9f716dcb615560ffd132234087c10ccc1f2c63 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.9.0-alpine@sha256:8e015de364a2eb2ed7c52a558e9f716dcb615560ffd132234087c10ccc1f2c63 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.9.0-alpine@sha256:8e015de364a2eb2ed7c52a558e9f716dcb615560ffd132234087c10ccc1f2c63 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.9.0-alpine@sha256:8e015de364a2eb2ed7c52a558e9f716dcb615560ffd132234087c10ccc1f2c63 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
