FROM node:19.6.1-alpine@sha256:78fa26eb2b8081e9005253e816ed75eaf6f828feeca1e1956f476356f050d816 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.6.1-alpine@sha256:78fa26eb2b8081e9005253e816ed75eaf6f828feeca1e1956f476356f050d816 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.6.1-alpine@sha256:78fa26eb2b8081e9005253e816ed75eaf6f828feeca1e1956f476356f050d816 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.6.1-alpine@sha256:78fa26eb2b8081e9005253e816ed75eaf6f828feeca1e1956f476356f050d816 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.6.1-alpine@sha256:78fa26eb2b8081e9005253e816ed75eaf6f828feeca1e1956f476356f050d816 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.6.1-alpine@sha256:78fa26eb2b8081e9005253e816ed75eaf6f828feeca1e1956f476356f050d816 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
