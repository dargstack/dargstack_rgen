FROM node:17.8.0-alpine@sha256:0f923922724e7d04a699ceb7b92b8383ec093b4e249804c8bd94886426443bff AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
