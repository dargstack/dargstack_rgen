FROM node:19.7.0-alpine@sha256:155e324802ebfdd3f508340dcb0cd4a7510f8594802a2e53150f171ae8aa2462 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.7.0-alpine@sha256:155e324802ebfdd3f508340dcb0cd4a7510f8594802a2e53150f171ae8aa2462 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.7.0-alpine@sha256:155e324802ebfdd3f508340dcb0cd4a7510f8594802a2e53150f171ae8aa2462 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.7.0-alpine@sha256:155e324802ebfdd3f508340dcb0cd4a7510f8594802a2e53150f171ae8aa2462 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.7.0-alpine@sha256:155e324802ebfdd3f508340dcb0cd4a7510f8594802a2e53150f171ae8aa2462 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.7.0-alpine@sha256:155e324802ebfdd3f508340dcb0cd4a7510f8594802a2e53150f171ae8aa2462 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
