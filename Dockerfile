FROM node:20.15.1-alpine@sha256:c42da7e09507eb725474dd3dbcbee248cb90a7d489f0f9aeb5d3222eab0728c8 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.15.1-alpine@sha256:c42da7e09507eb725474dd3dbcbee248cb90a7d489f0f9aeb5d3222eab0728c8 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM prepare AS build

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline --ignore-scripts


FROM prepare AS test

RUN corepack enable && \
    pnpm run test


FROM prepare AS collect

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.15.1-alpine@sha256:c42da7e09507eb725474dd3dbcbee248cb90a7d489f0f9aeb5d3222eab0728c8 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
