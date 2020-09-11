FROM node:14.10.1-alpine@sha256:cf4fbc268ed5118f97114d7bb3dd6dd01728c55ec9d7ec10bb1231b0084e0bba AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
