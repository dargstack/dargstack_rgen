FROM node:17.1.0-alpine@sha256:707d4ffcaafe2bcc9f279fcd40591e0f6eb997be7f1f886796da2c17af871124 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
