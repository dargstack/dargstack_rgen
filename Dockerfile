FROM node:18.9.1-alpine@sha256:3f2d9530d21df22bdd283203639d59e855aafa424acf72c5875e20a305d4e850 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
