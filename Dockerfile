FROM node:17.0.0-alpine@sha256:9ff001f1d05ef0e03e9459ee3bb7f807f1c836d322bea406caf37adfb095698d AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
