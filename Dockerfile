FROM node:14.15.0-alpine@sha256:dc9641311155f990b713df6ab2751c9dc487bd64dd66fb3a25dce673fd4167cc AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
