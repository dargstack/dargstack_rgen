FROM node:18.9.1-alpine@sha256:566ffe130bb0fd2d03d492333ad2e9c35fcf1f2c9d8be6311b3c29d6c138802a AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
