FROM node:14.16.1-alpine@sha256:a20a9661c97ef41c4ddb25a6df3db869f2f28bda1d5d5fa7fd35168dbe686c9a AS development

# https://github.com/typicode/husky/issues/821
ENV HUSKY_SKIP_INSTALL=1

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
