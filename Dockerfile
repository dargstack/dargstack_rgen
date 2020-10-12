FROM node:14.13.1-alpine@sha256:9a28dee760ed940c6b72bd0b5aca05cdb04a05f4328f6308c59b3d59903e5c30 AS development

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
