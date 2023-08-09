FROM node:20.5.0-alpine@sha256:efcfc9e818c3abe166cfcced1c9602cac29e08c83b273a4f280a87d4218daf8c AS development

WORKDIR /srv/app/

VOLUME /srv/app

ENTRYPOINT ["node", "./src/generator.cjs"]


FROM node:20.5.0-alpine@sha256:efcfc9e818c3abe166cfcced1c9602cac29e08c83b273a4f280a87d4218daf8c AS prepare

WORKDIR /srv/app/

COPY ./pnpm-lock.yaml ./

RUN corepack enable && \
    pnpm fetch

COPY ./ ./

RUN pnpm install --offline


FROM node:20.5.0-alpine@sha256:efcfc9e818c3abe166cfcced1c9602cac29e08c83b273a4f280a87d4218daf8c AS build

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

ENV NODE_ENV=production

RUN corepack enable && \
    pnpm install --offline


FROM node:20.5.0-alpine@sha256:efcfc9e818c3abe166cfcced1c9602cac29e08c83b273a4f280a87d4218daf8c AS test

WORKDIR /srv/app/

COPY --from=prepare /srv/app/ ./

RUN corepack enable && \
    pnpm run test


FROM node:20.5.0-alpine@sha256:efcfc9e818c3abe166cfcced1c9602cac29e08c83b273a4f280a87d4218daf8c AS collect

WORKDIR /srv/app/

COPY --from=build /srv/app/ /srv/app/
COPY --from=test /srv/app/package.json /tmp/package.json


FROM node:20.5.0-alpine@sha256:efcfc9e818c3abe166cfcced1c9602cac29e08c83b273a4f280a87d4218daf8c AS production

WORKDIR /srv/app/

COPY --from=collect /srv/app/ ./

ENTRYPOINT ["node", "./src/generator.cjs"]
