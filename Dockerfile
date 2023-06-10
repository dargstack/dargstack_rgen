FROM node:20.3.0-alpine@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.3.0-alpine@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.3.0-alpine@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.3.0-alpine@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.3.0-alpine@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.3.0-alpine@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
