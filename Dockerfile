FROM node:18.9.0-alpine@sha256:831d5eca5b7437a8132031a25bd18bdb0399e7415d4e8e02a8c14426b6dcf17f AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
