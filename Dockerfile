FROM node:16.8.0-alpine@sha256:abd76715630b2fbed5de9cbcf8b44beb94bfd1ccb972e8dfc3eb5cdf4b1719d0 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
