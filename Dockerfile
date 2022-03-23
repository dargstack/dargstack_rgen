FROM node:17.8.0-alpine@sha256:c6fa8b1ea6d027c8fcbe33dee878e5b01c172ea65f3c1aed308008ebbc9db0b2 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
