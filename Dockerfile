FROM node:16.10.0-alpine@sha256:3da1c08529fef7007d57d2133a0feb0fa8c60fdd4ad6691978f9dfcb0365b430 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
