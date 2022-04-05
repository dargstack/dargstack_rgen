FROM node:17.8.0-alpine@sha256:57106b8c14fdfc6d1ee2b27de320a4d17db55032c4e6e99ff1021d81ef01c328 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
