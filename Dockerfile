FROM node:16.5.0-alpine@sha256:9a71d4fe6089bcd1cb7ab064c1624a3d5610be3c1404783b9374557e4474f717 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
