FROM node:22.21.1-alpine AS base-image

ENV CI=true

WORKDIR /srv/app/

RUN corepack enable


FROM base-image AS development

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.js"]


FROM base-image AS prepare

COPY ./pnpm-lock.yaml package.json ./

RUN pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM prepare AS build

ENV NODE_ENV=production

RUN pnpm install --offline --ignore-scripts --prod


FROM prepare AS lint

RUN pnpm run lint


FROM prepare AS test

RUN pnpm run test


FROM prepare AS collect

COPY --from=build /srv/app/ /srv/app/
COPY --from=lint /srv/app/package.json /dev/null
COPY --from=test /srv/app/package.json /dev/null


FROM collect AS production

ENTRYPOINT ["node", "./src/generator.js"]
