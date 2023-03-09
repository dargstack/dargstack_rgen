FROM node:19.7.0-alpine@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:19.7.0-alpine@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN npm install -g pnpm && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:19.7.0-alpine@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN npm install -g pnpm && \
    pnpm install --offline


FROM node:19.7.0-alpine@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN npm install -g pnpm && \
    pnpm run test


FROM node:19.7.0-alpine@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:19.7.0-alpine@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
