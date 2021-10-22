FROM node:17.0.1-alpine@sha256:cbc3f886fa2da00bbe56317c0a1c560be8d0f80df51e789a135700c26528cac9 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
