FROM node:14.8.0-alpine@sha256:95562acd0ed9398e21babe6b90fd8ac3974709c9338155e2b4ef1c0824e60be1 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
