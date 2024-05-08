FROM node:20.13.0-alpine@sha256:fac6f741d51194c175c517f66bc3125588313327ad7e0ecd673e161e4fa807f3 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.13.0-alpine@sha256:fac6f741d51194c175c517f66bc3125588313327ad7e0ecd673e161e4fa807f3 AS prepare

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


FROM node:20.13.0-alpine@sha256:fac6f741d51194c175c517f66bc3125588313327ad7e0ecd673e161e4fa807f3 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
