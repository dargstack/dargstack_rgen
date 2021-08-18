FROM node:16.6.2-alpine@sha256:22e6e08e5be7d772daf552e0ac273fd6304bd9c374e5e1596dd4fe5e8c241e1e AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
