FROM node:19.0.0-alpine@sha256:bdd47da7e6d246549db69891f5865d82dfc9961eae897197d85a030f254980b1 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
