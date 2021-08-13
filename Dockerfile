FROM node:16.6.2-alpine@sha256:2d7a22f6d738af0dc829d181e8a95d6239460a185f2dafee531b3c79b6c9334c AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
