FROM node:16.6.2-alpine@sha256:4e70ed424e6310602d6137b353cc3e0ae066c4214ce17967ca9336b80b3a7fbd AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
