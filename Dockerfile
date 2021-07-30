FROM node:16.6.0-alpine@sha256:47af330a6d6dcb706a3fadf3ecebe50f73064831991f9a4c5f21a46cfc6d97d7 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
