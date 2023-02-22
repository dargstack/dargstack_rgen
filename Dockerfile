FROM node:19.7.0-alpine@sha256:667dc6ed8fc6623ccd21cb5fa355c90f848daaf5d6df96bc940869bfdf91c19a AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.7.0-alpine@sha256:667dc6ed8fc6623ccd21cb5fa355c90f848daaf5d6df96bc940869bfdf91c19a AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.7.0-alpine@sha256:667dc6ed8fc6623ccd21cb5fa355c90f848daaf5d6df96bc940869bfdf91c19a AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.7.0-alpine@sha256:667dc6ed8fc6623ccd21cb5fa355c90f848daaf5d6df96bc940869bfdf91c19a AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.7.0-alpine@sha256:667dc6ed8fc6623ccd21cb5fa355c90f848daaf5d6df96bc940869bfdf91c19a AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.7.0-alpine@sha256:667dc6ed8fc6623ccd21cb5fa355c90f848daaf5d6df96bc940869bfdf91c19a AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
