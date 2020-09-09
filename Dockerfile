FROM node:14.10.0-alpine@sha256:3d1bdb8c2d026003273dd229d6f1ac2252be4d6fb5676a15f987f7e761e254d2 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
