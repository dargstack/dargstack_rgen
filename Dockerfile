FROM node:16.6.2-alpine@sha256:64e7fb64b5d6a39566d0ad25c0692d8454fe5f26e40be0f8b9017476f73890c9 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
