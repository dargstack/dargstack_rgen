FROM node:18.10.0-alpine@sha256:d4935e4a77d3a9aca897dc3610f7a9abc83732ba4075439fbdb46a517c07d81e AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
