FROM node:16.2.0-alpine@sha256:e5615005591e2450e782fa82b10bf31e4c3a90b00f4f47f3691bcb4c03c5b1a2 AS development

# https://github.com/typicode/husky/issues/821
ENV HUSKY_SKIP_INSTALL=1

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
