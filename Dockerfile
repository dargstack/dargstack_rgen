FROM node:16.8.0-alpine@sha256:e250bb9fbb7b7dfa462aff25deffe986e448e0177838fee8b69103810f06932b AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
