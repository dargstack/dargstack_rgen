FROM node:16.9.0-alpine@sha256:697313d55634a94b36cc5cf75a687b210c7e4a8e433e64d80893bcfca9b11de8 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
