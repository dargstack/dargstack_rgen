FROM node:14.15.1-alpine@sha256:05a2f563ff66492dbe3c82cb482d6c1bbaecefcac4d42bd3744c7693028c9e44 AS development

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
