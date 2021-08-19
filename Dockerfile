FROM node:16.7.0-alpine@sha256:f74b682f5711a09e200c305e08305d18a0d2afe4ec4f8fe925ab080c2118b3e7 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
