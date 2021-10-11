FROM node:16.11.0-alpine@sha256:9ceec9adb312844a7ed579d4aaa8d95efd80748ba41ee50786eed9f71f904e29 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
