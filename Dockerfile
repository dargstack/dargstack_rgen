FROM node:17.1.0-alpine@sha256:993bdfb0da7ae8fa4dad7282f797e3e26e88f810d410e0b0409d132d1fb17af3 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
