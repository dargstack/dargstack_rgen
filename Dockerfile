FROM node:20.11.1-alpine@sha256:842159a809c86c28a799b235f95e6010aa64d967d98eee0db4db5979d33dd43e AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.11.1-alpine@sha256:842159a809c86c28a799b235f95e6010aa64d967d98eee0db4db5979d33dd43e AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.11.1-alpine@sha256:842159a809c86c28a799b235f95e6010aa64d967d98eee0db4db5979d33dd43e AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline --ignore-scripts


FROM node:20.11.1-alpine@sha256:842159a809c86c28a799b235f95e6010aa64d967d98eee0db4db5979d33dd43e AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.11.1-alpine@sha256:842159a809c86c28a799b235f95e6010aa64d967d98eee0db4db5979d33dd43e AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.11.1-alpine@sha256:842159a809c86c28a799b235f95e6010aa64d967d98eee0db4db5979d33dd43e AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
