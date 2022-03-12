FROM node:17.7.1-alpine@sha256:8c62619815dd2d7642f9e9c7f30d7016249a41175dfca0aaf248171960e4cc80 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
