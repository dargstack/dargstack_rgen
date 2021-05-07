FROM node:16.1.0-alpine@sha256:8704247878fe10eddfcb5c26540112b15e50d21ce8e5c7a7f6caf5cf857de219 AS development

# https://github.com/typicode/husky/issues/821
ENV HUSKY_SKIP_INSTALL=1

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
