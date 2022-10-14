FROM node:18.11.0-alpine@sha256:d1e09ed04f228ed68024460e77b777c24025b39d6ee426308aa703fe5282a18d AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
