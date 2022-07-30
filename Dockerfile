FROM node:18.7.0-alpine@sha256:4c8f734f33b4c8bb41c3caf17c61e6828e45cdc39dcc3fd495d0fb3213b33cfe AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
