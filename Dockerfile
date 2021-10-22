FROM node:17.0.1-alpine@sha256:8557b99c367dd149fa9bae353b6bcc8dfecb3193d1a795c4971a51b8e5590e60 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
