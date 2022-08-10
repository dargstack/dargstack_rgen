FROM node:18.7.0-alpine@sha256:39eee9aa771257847d3d8bcb7f775439d0267197060053761b54021bcae6338e AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
