FROM node:17.8.0-alpine@sha256:29b18ec3a6e20178c4284e57649aa543a35bcd27d674600f90e9dc974130393c AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
