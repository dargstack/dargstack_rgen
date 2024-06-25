FROM node:20.15.0-alpine@sha256:0ccc08fadfe696f2959f59404ce0d90461c834a7465c4a563c62c0fef4089885 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.15.0-alpine@sha256:0ccc08fadfe696f2959f59404ce0d90461c834a7465c4a563c62c0fef4089885 AS prepare

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


FROM node:20.15.0-alpine@sha256:0ccc08fadfe696f2959f59404ce0d90461c834a7465c4a563c62c0fef4089885 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
