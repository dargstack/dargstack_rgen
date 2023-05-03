FROM node:20.0.0-alpine@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.0.0-alpine@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.0.0-alpine@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.0.0-alpine@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.0.0-alpine@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.0.0-alpine@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
