FROM node:19.0.0-alpine@sha256:7eaaf14ed8b7cc1d716b965bff7554d7d2e1127558ee8108d3844dc3a1122234 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
