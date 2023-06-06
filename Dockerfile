FROM node:20.2.0-alpine@sha256:59ac6536ba03469adc3847f23a4f223b0418fba21c90168d703f61bd84125989 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.2.0-alpine@sha256:59ac6536ba03469adc3847f23a4f223b0418fba21c90168d703f61bd84125989 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.2.0-alpine@sha256:59ac6536ba03469adc3847f23a4f223b0418fba21c90168d703f61bd84125989 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.2.0-alpine@sha256:59ac6536ba03469adc3847f23a4f223b0418fba21c90168d703f61bd84125989 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.2.0-alpine@sha256:59ac6536ba03469adc3847f23a4f223b0418fba21c90168d703f61bd84125989 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.2.0-alpine@sha256:59ac6536ba03469adc3847f23a4f223b0418fba21c90168d703f61bd84125989 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
