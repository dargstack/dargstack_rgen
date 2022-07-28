FROM node:18.7.0-alpine@sha256:af502799866e8044883622a66828a2536447123d9dd415f9f09e8259bc4c52ee AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
