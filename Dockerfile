FROM node:19.4.0-alpine@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.4.0-alpine@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.4.0-alpine@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.4.0-alpine@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.4.0-alpine@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.4.0-alpine@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
