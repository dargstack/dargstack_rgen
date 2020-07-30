FROM node:14.7.0-alpine@sha256:2c67c1f5b8907b102920153927b5d7ef85e3f28c67ddf32a5392a4dce1842f61 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
