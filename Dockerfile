FROM node:17.2.0-alpine@sha256:e64dc950217610c86f29aef803b123e1b6a4a372d6fa4bcf71f9ddcbd39eba5c AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
