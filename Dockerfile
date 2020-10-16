FROM node:14.14.0-alpine@sha256:11c2bffbb8ef1f7ddf601c52128ec3f1e0dac408c1ce4256f8c372be4cc6f264 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
