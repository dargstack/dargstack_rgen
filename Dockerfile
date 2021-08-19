FROM node:16.7.0-alpine@sha256:597864180891b2498e104ace823507882aa9ae132115af63dd8fc611bb300984 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
