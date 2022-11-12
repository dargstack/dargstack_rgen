FROM node:19.0.1-alpine@sha256:389b6e6e2d9ab5fc0e7cad3e24ac8ac8753b3437d96ea7eaf3306e0be506abf5 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
