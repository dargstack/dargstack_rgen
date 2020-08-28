FROM node:14.9.0-alpine@sha256:409946b83711e15abb0945da71b2d41b6f29f360c9a4fbca5db8d04953534285 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
