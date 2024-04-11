FROM node:20.12.2-alpine@sha256:3321ad83759c5bb1a18575b40606dee561bbdb6b2b008327c17d85adeb3939d1 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.12.2-alpine@sha256:3321ad83759c5bb1a18575b40606dee561bbdb6b2b008327c17d85adeb3939d1 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.12.2-alpine@sha256:3321ad83759c5bb1a18575b40606dee561bbdb6b2b008327c17d85adeb3939d1 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline --ignore-scripts


FROM node:20.12.2-alpine@sha256:3321ad83759c5bb1a18575b40606dee561bbdb6b2b008327c17d85adeb3939d1 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.12.2-alpine@sha256:3321ad83759c5bb1a18575b40606dee561bbdb6b2b008327c17d85adeb3939d1 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.12.2-alpine@sha256:3321ad83759c5bb1a18575b40606dee561bbdb6b2b008327c17d85adeb3939d1 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
