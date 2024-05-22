FROM node:20.13.1-alpine@sha256:49344ed404f74b38ba538026c3f2a83444a13363585b5efec25fe6f53e0fbb00 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.13.1-alpine@sha256:49344ed404f74b38ba538026c3f2a83444a13363585b5efec25fe6f53e0fbb00 AS prepare

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


FROM node:20.13.1-alpine@sha256:49344ed404f74b38ba538026c3f2a83444a13363585b5efec25fe6f53e0fbb00 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
