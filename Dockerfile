FROM node:16.8.0-alpine@sha256:1ee1478ef46a53fc0584729999a0570cf2fb174fbfe0370edbf09680b2378b56 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
