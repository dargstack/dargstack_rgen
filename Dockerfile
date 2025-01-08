FROM node:22.13.0-alpine@sha256:bbe9b971cb51593d8a4b8aa81ab031f2b3f3a6344d4fb297335a5fb058ad8c46 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:22.13.0-alpine@sha256:bbe9b971cb51593d8a4b8aa81ab031f2b3f3a6344d4fb297335a5fb058ad8c46 AS prepare

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


FROM node:22.13.0-alpine@sha256:bbe9b971cb51593d8a4b8aa81ab031f2b3f3a6344d4fb297335a5fb058ad8c46 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
