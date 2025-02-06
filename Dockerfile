FROM node:22.13.1-alpine@sha256:e2b39f7b64281324929257d0f8004fb6cb4bf0fdfb9aa8cedb235a766aec31da AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:22.13.1-alpine@sha256:e2b39f7b64281324929257d0f8004fb6cb4bf0fdfb9aa8cedb235a766aec31da AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml package.json ./

RUN npm install -g corepack@latest \
    # TODO: remove (https://github.com/nodejs/corepack/issues/612)
    && corepack enable \
    && pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM prepare AS build

ENV NODE_ENV=production

RUN npm install -g corepack@latest \
    # TODO: remove (https://github.com/nodejs/corepack/issues/612)
    && corepack enable \
    && pnpm install --offline --ignore-scripts --prod


FROM prepare AS test

RUN npm install -g corepack@latest \
    # TODO: remove (https://github.com/nodejs/corepack/issues/612)
    && corepack enable \
    && pnpm run test


FROM prepare AS collect

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:22.13.1-alpine@sha256:e2b39f7b64281324929257d0f8004fb6cb4bf0fdfb9aa8cedb235a766aec31da AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
