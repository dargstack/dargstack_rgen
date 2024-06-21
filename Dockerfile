FROM node:20.14.0-alpine@sha256:6ce211be2226e86d61413dc19f11cab7ab96205837811c6356881a4157cea0c5 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:20.14.0-alpine@sha256:6ce211be2226e86d61413dc19f11cab7ab96205837811c6356881a4157cea0c5 AS prepare

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


FROM node:20.14.0-alpine@sha256:6ce211be2226e86d61413dc19f11cab7ab96205837811c6356881a4157cea0c5 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
