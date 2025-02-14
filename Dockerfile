FROM node:22.14.0-alpine@sha256:f93d93d31e202006196d5d22babb9bec7615b9a101744717df815d3d87e275f8 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM node:22.14.0-alpine@sha256:f93d93d31e202006196d5d22babb9bec7615b9a101744717df815d3d87e275f8 AS prepare

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


FROM node:22.14.0-alpine@sha256:f93d93d31e202006196d5d22babb9bec7615b9a101744717df815d3d87e275f8 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.js"]
