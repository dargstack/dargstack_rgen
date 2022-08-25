FROM node:18.8.0-alpine@sha256:d5d7d8e860cb38063ac0735753bed467d1360ece5ccb7c99747726bb9399ccfa AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
