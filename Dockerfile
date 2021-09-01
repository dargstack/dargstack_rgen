FROM node:16.8.0-alpine@sha256:fc078d15197e4c49a33d8bb0253e61f8032c34680c3732a2149d8528f96b7adb AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
