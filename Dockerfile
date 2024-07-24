FROM node:20.16.0-alpine@sha256:1a8bc4dc4720f0eb2f68d1883fd09f939103bd6df3848e0ffdc919d7fbf4dee1 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.16.0-alpine@sha256:1a8bc4dc4720f0eb2f68d1883fd09f939103bd6df3848e0ffdc919d7fbf4dee1 AS prepare

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


FROM node:20.16.0-alpine@sha256:1a8bc4dc4720f0eb2f68d1883fd09f939103bd6df3848e0ffdc919d7fbf4dee1 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
