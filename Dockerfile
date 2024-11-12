FROM node:22.11.0-alpine@sha256:f8c7230e119ab657a4adda992f7dad2b2b068029c7710f53d930673a8eb2a1e8 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:22.11.0-alpine@sha256:f8c7230e119ab657a4adda992f7dad2b2b068029c7710f53d930673a8eb2a1e8 AS prepare

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


FROM node:22.11.0-alpine@sha256:f8c7230e119ab657a4adda992f7dad2b2b068029c7710f53d930673a8eb2a1e8 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
