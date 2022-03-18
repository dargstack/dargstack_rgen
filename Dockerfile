FROM node:17.7.1-alpine@sha256:1cc03b302881bab0afe450fd51138718c81156d107427dbebb3c2301819620a7 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
