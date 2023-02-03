FROM node:19.6.0-alpine@sha256:72b0f918ad76b5ef68c6243869fab5800d7393c1dcccf54ef00958c2abc8164a AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.6.0-alpine@sha256:72b0f918ad76b5ef68c6243869fab5800d7393c1dcccf54ef00958c2abc8164a AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.6.0-alpine@sha256:72b0f918ad76b5ef68c6243869fab5800d7393c1dcccf54ef00958c2abc8164a AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.6.0-alpine@sha256:72b0f918ad76b5ef68c6243869fab5800d7393c1dcccf54ef00958c2abc8164a AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.6.0-alpine@sha256:72b0f918ad76b5ef68c6243869fab5800d7393c1dcccf54ef00958c2abc8164a AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.6.0-alpine@sha256:72b0f918ad76b5ef68c6243869fab5800d7393c1dcccf54ef00958c2abc8164a AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
