FROM node:20.12.1-alpine@sha256:d21256de67597675524c5f75c72bc483ef5c10dc3b035f0459fd10de3e82b3c9 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.12.1-alpine@sha256:d21256de67597675524c5f75c72bc483ef5c10dc3b035f0459fd10de3e82b3c9 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.12.1-alpine@sha256:d21256de67597675524c5f75c72bc483ef5c10dc3b035f0459fd10de3e82b3c9 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline --ignore-scripts


FROM node:20.12.1-alpine@sha256:d21256de67597675524c5f75c72bc483ef5c10dc3b035f0459fd10de3e82b3c9 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.12.1-alpine@sha256:d21256de67597675524c5f75c72bc483ef5c10dc3b035f0459fd10de3e82b3c9 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.12.1-alpine@sha256:d21256de67597675524c5f75c72bc483ef5c10dc3b035f0459fd10de3e82b3c9 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
