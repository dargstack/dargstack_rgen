FROM node:19.8.1-alpine@sha256:ce9dd01fefe302dce994c07fb32b55403a79acd693c9d841571dc14fc47826c8 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.8.1-alpine@sha256:ce9dd01fefe302dce994c07fb32b55403a79acd693c9d841571dc14fc47826c8 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.8.1-alpine@sha256:ce9dd01fefe302dce994c07fb32b55403a79acd693c9d841571dc14fc47826c8 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.8.1-alpine@sha256:ce9dd01fefe302dce994c07fb32b55403a79acd693c9d841571dc14fc47826c8 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.8.1-alpine@sha256:ce9dd01fefe302dce994c07fb32b55403a79acd693c9d841571dc14fc47826c8 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.8.1-alpine@sha256:ce9dd01fefe302dce994c07fb32b55403a79acd693c9d841571dc14fc47826c8 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
