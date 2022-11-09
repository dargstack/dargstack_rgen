FROM node:19.0.1-alpine@sha256:00c5c0850a48bbbf0136f1c886bad52784f9816a8d314a99307d734598359ed4 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
