FROM node:19.0.0-alpine@sha256:5a7b6772549bfbb856769f9e3d090812450399a746654a8b89a80b2026591902 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
