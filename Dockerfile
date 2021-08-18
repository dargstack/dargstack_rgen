FROM node:16.6.2-alpine@sha256:f80bf0b8ce2905366ea1734545a04d76fb76c1768645753e6bb0d22ee789d371 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
