FROM node:16.4.2-alpine@sha256:55cd026b9a7e4b2cbd5d0c67bf0c9feb151798a760a4ede5eb3ef2de026cddec AS development

# https://github.com/typicode/husky/issues/821
ENV HUSKY_SKIP_INSTALL=1

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
