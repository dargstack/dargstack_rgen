FROM node:18.7.0-alpine@sha256:7d563fd33907c471a57012c722a1cf7ca76a928c2d2145ab114351ba4313b3f8 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
