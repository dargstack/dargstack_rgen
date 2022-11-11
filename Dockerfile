FROM node:19.0.1-alpine@sha256:083a23fe246cc82294f64e154f5d6bce8c90b9fc8f2dce54d3c58d41ddd8f8c8 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
