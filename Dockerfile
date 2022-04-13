FROM node:17.9.0-alpine@sha256:f61706c2cb120c06cf4fdcf60a2822a804b0bd90b6b2209be1ee00db1d33130c AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
