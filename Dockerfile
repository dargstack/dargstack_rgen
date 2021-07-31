FROM node:16.6.0-alpine@sha256:a55cd676d1aec59d871855b86984063c8854e67a7f552af66418c5068103a509 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
