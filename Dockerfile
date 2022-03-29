FROM node:17.8.0-alpine@sha256:0c88ddeb949638cbaa8438a95aff1fce0e7c83e09c6f154245a1a8b0a1becd9e AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
