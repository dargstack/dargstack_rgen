FROM node:16.8.0-alpine@sha256:24dcabd9b8315dba05dcc68b9bd372dde47c58367dbd8d273612643d4489ddb0 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
