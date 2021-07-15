FROM node:16.5.0-alpine@sha256:50b33102c307e04f73817dad87cdae145b14782875495ddd950b5a48e4937c70 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
