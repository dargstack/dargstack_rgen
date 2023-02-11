FROM node:19.6.0-alpine@sha256:103506464ad0c73abd7f80f6ce547545ef2d523fdab318eacc4d0fa44bae9b8f AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.6.0-alpine@sha256:103506464ad0c73abd7f80f6ce547545ef2d523fdab318eacc4d0fa44bae9b8f AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.6.0-alpine@sha256:103506464ad0c73abd7f80f6ce547545ef2d523fdab318eacc4d0fa44bae9b8f AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.6.0-alpine@sha256:103506464ad0c73abd7f80f6ce547545ef2d523fdab318eacc4d0fa44bae9b8f AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.6.0-alpine@sha256:103506464ad0c73abd7f80f6ce547545ef2d523fdab318eacc4d0fa44bae9b8f AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.6.0-alpine@sha256:103506464ad0c73abd7f80f6ce547545ef2d523fdab318eacc4d0fa44bae9b8f AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
