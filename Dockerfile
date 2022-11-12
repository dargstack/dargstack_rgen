FROM node:19.0.1-alpine@sha256:2241dcb089d4d46d9321cc69f67769f741a04b08c9ead1530e8054d7eaac97a5 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
