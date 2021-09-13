FROM node:16.9.1-alpine@sha256:a2b99f95311def1095e5b9604a81956f4109d9a512a44c86fc382f472cad1d91 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
