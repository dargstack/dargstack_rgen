FROM node:19.2.0-alpine@sha256:2770c782de28bf078850d4b53afc46befa4c229f2c65564d0123d604e6aac1a9 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
