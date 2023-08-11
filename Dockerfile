FROM node:20.5.1-alpine@sha256:5fd1bdbbb0d96d68c65a5c18a70ff9819ff1dc2889ac4c390bad4f79834c7bb3 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.5.1-alpine@sha256:5fd1bdbbb0d96d68c65a5c18a70ff9819ff1dc2889ac4c390bad4f79834c7bb3 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.5.1-alpine@sha256:5fd1bdbbb0d96d68c65a5c18a70ff9819ff1dc2889ac4c390bad4f79834c7bb3 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.5.1-alpine@sha256:5fd1bdbbb0d96d68c65a5c18a70ff9819ff1dc2889ac4c390bad4f79834c7bb3 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.5.1-alpine@sha256:5fd1bdbbb0d96d68c65a5c18a70ff9819ff1dc2889ac4c390bad4f79834c7bb3 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.5.1-alpine@sha256:5fd1bdbbb0d96d68c65a5c18a70ff9819ff1dc2889ac4c390bad4f79834c7bb3 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
