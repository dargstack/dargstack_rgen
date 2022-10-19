FROM node:19.0.0-alpine@sha256:48e43334c84762aa05c18dac37ec5ca396e9d55c5cb053f15cd4edbfe89a0914 AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
