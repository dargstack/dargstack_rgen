FROM node:16.6.0-alpine@sha256:36e01fc96f93d48cc31a6cf44d6d2fbd35808b219269740f4c544896d5536c2e AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
