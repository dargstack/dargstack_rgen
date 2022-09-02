FROM node:18.8.0-alpine@sha256:8437bc872a71f3b15a384ff32d098a68e06b440c0d9ec3eb4b4fa26ca16f2b30 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
