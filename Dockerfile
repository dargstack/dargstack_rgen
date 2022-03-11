FROM node:17.7.1-alpine@sha256:dc8b656211740222bcc3a5c90fa6ba5e545f779660c67f5d3f155ff946d05aaa AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
