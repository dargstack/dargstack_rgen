FROM node:14.11.0-alpine@sha256:328f4041e9af2db8252b3266691dc095971fb03f9f6f9e9ffb45b0c9752cd903 AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "generator.js"]
