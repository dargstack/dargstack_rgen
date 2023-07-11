FROM node:20.4.0-alpine@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.4.0-alpine@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.4.0-alpine@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.4.0-alpine@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.4.0-alpine@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.4.0-alpine@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
