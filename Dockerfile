FROM node:14.6.0-alpine@sha256:1aa9089d948437ff5fe4076b543fd3a0146fe23ffcf35de715b9f234b46f40c6 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
