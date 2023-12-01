FROM node:20.10.0-alpine@sha256:32427bc0620132b2d9e79e405a1b27944d992501a20417a7f407427cc4c2b672 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.10.0-alpine@sha256:32427bc0620132b2d9e79e405a1b27944d992501a20417a7f407427cc4c2b672 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.10.0-alpine@sha256:32427bc0620132b2d9e79e405a1b27944d992501a20417a7f407427cc4c2b672 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.10.0-alpine@sha256:32427bc0620132b2d9e79e405a1b27944d992501a20417a7f407427cc4c2b672 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.10.0-alpine@sha256:32427bc0620132b2d9e79e405a1b27944d992501a20417a7f407427cc4c2b672 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.10.0-alpine@sha256:32427bc0620132b2d9e79e405a1b27944d992501a20417a7f407427cc4c2b672 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
