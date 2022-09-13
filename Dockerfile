FROM node:18.9.0-alpine@sha256:370c4e3b4da19d62f0afc7e6c5f78e3d28d861680c324144a56141fd43c1498c AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
