FROM node:20.11.1-alpine@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.11.1-alpine@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.11.1-alpine@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline --ignore-scripts


FROM node:20.11.1-alpine@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.11.1-alpine@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.11.1-alpine@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
