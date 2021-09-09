FROM node:16.9.0-alpine@sha256:a25ca168fccced6852b89728ddfda1309addcd6f307f3db067e48ba2d58248ed AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
