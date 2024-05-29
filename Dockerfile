FROM node:20.14.0-alpine@sha256:da1fb4e470cbe065c849c47c1187a592f7505c1a679f5b3f845ea88b30f763a6 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.14.0-alpine@sha256:da1fb4e470cbe065c849c47c1187a592f7505c1a679f5b3f845ea88b30f763a6 AS prepare

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


FROM node:20.14.0-alpine@sha256:da1fb4e470cbe065c849c47c1187a592f7505c1a679f5b3f845ea88b30f763a6 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
