FROM node:18.10.0-alpine@sha256:fd5f5b9507f909dee4ba9c5ec554cae3f8d3761fa82f6226df1a269512c6b8eb AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
