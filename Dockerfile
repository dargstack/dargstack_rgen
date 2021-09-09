FROM node:16.9.0-alpine@sha256:97a4779116fb0776a8a794f6be4826dde6455c5274523a912d84efd855027abc AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
