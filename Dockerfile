FROM node:16.5.0-alpine@sha256:22f0bdfef392964077f96768203885ed895d66afe469f61a83bbbbb8af04b138 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
