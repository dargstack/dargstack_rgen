FROM node:17.3.1-alpine@sha256:7ef8e673a9ea7b1dfaae292bf8faf549bb81ba60f68087454cef143698bdf2c4 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
