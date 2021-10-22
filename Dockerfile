FROM node:17.0.1-alpine@sha256:468e8d26c56d3813c5454749309b723faf2c9e3ff48d4c2f374d2f1c5d46045f AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
