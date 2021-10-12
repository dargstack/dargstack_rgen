FROM node:16.11.0-alpine@sha256:6d5ecd68b7d28e63fbec26ae4d05fa679a7003325d8e4ea72e6dc318d9869899 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
