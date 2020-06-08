FROM node:14.4.0-alpine@sha256:796fbe3509bdd36aef0e62508379f84e32a172062b7a37cb3609dee1567893b9 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
