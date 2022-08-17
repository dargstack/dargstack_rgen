FROM node:18.7.0-alpine@sha256:02a5466bd5abde6cde29c16d83e2f5a10eec11c8dcefa667a2c9f88a7fa8b0b3 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
