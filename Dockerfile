FROM node:16.6.2-alpine@sha256:bd39f3e62841ba73ed86eec0edfd1b1867ae2153b491545726ece4e328ba54fc AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
