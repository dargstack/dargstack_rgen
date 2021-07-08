FROM node:16.4.2-alpine@sha256:b7e2d75ecd585feed57be69cd3dee973e5c498241e64906899b3baa2169fb35a AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
