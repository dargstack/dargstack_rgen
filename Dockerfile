FROM node:18.10.0-alpine@sha256:304e707e9283ac64af3bae2a8d6b8b16dfe00d91f739d80015bd0b74147c6840 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
