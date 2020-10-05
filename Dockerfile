FROM node:14.13.0-alpine@sha256:df7d661e1b89cd4c774e445c78862a4397340bab613fa57b97056d01cdc33e44 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
