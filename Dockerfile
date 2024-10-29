FROM node:22.10.0-alpine@sha256:fc95a044b87e95507c60c1f8c829e5d98ddf46401034932499db370c494ef0ff AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:22.10.0-alpine@sha256:fc95a044b87e95507c60c1f8c829e5d98ddf46401034932499db370c494ef0ff AS prepare

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


FROM node:22.10.0-alpine@sha256:fc95a044b87e95507c60c1f8c829e5d98ddf46401034932499db370c494ef0ff AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
