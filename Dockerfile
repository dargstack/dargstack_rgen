FROM node:14.5.0-alpine@sha256:db9d074278b87089a6e8c7b36ae3e645ce783b8fababc28f5c35f7bef49553d2 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
