FROM node:19.4.0-alpine@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.4.0-alpine@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.4.0-alpine@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.4.0-alpine@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.4.0-alpine@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.4.0-alpine@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
