FROM node:16.6.1-alpine@sha256:976d0b9fbb88e2796019615b8a29de54c6559fb887f115dd22e6a2804e0b3063 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
