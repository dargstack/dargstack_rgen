FROM node:18.9.1-alpine@sha256:449139de1290831c25998282196d386db979088f4c7597d31f007d5b04b95464 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
