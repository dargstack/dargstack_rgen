FROM node:16.6.2-alpine@sha256:5ce99edc816a6923df0844c3d7934bb8da36158097aa8a7183a2c896113d9f9e AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
