FROM node:22.15.1-alpine@sha256:152270cd4bd094d216a84cbc3c5eb1791afb05af00b811e2f0f04bdc6c473602 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:22.15.1-alpine@sha256:152270cd4bd094d216a84cbc3c5eb1791afb05af00b811e2f0f04bdc6c473602 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml package.json ./

RUN corepack enable \
    && pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM prepare AS build

ENV NODE_ENV=production

RUN corepack enable \
    && pnpm install --offline --ignore-scripts --prod


FROM prepare AS test

RUN corepack enable \
    && pnpm run test


FROM prepare AS collect

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:22.15.1-alpine@sha256:152270cd4bd094d216a84cbc3c5eb1791afb05af00b811e2f0f04bdc6c473602 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
