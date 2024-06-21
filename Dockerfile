FROM node:20.14.0-alpine@sha256:6601779ef07888825fb71feda27b998b5099688d6ff2bbbc94810b2108f32e45 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.14.0-alpine@sha256:6601779ef07888825fb71feda27b998b5099688d6ff2bbbc94810b2108f32e45 AS prepare

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


FROM node:20.14.0-alpine@sha256:6601779ef07888825fb71feda27b998b5099688d6ff2bbbc94810b2108f32e45 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
