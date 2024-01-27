FROM node:20.11.0-alpine@sha256:a2bb114e1f87c3411ca78de61c2100685eba176481355e32899210c7f51f98d4 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.11.0-alpine@sha256:a2bb114e1f87c3411ca78de61c2100685eba176481355e32899210c7f51f98d4 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.11.0-alpine@sha256:a2bb114e1f87c3411ca78de61c2100685eba176481355e32899210c7f51f98d4 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline --ignore-scripts


FROM node:20.11.0-alpine@sha256:a2bb114e1f87c3411ca78de61c2100685eba176481355e32899210c7f51f98d4 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.11.0-alpine@sha256:a2bb114e1f87c3411ca78de61c2100685eba176481355e32899210c7f51f98d4 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.11.0-alpine@sha256:a2bb114e1f87c3411ca78de61c2100685eba176481355e32899210c7f51f98d4 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
