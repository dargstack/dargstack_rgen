FROM node:18.7.0-alpine@sha256:b718f847a580064e7ad90103f99509a31a0ca092e6807a84011f28c5a020f80b AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
