FROM node:14.15.5-alpine@sha256:5edad160011cc8cfb69d990e9ae1cb2681c0f280178241d58eba05b5bfc34047 AS development

# https://github.com/typicode/husky/issues/821
ENV HUSKY_SKIP_INSTALL=1

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
