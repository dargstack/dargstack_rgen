FROM node:18.10.0-alpine@sha256:f829c27f4f7059609e650023586726a126db25aded0c401e836cb81ab63475ff AS development

ENV HUSKY=0

WORKDIR /srv/app/

# Copy package files first to increase build cache hits.
COPY ./package.json ./yarn.lock ./

RUN yarn install && yarn cache clean

COPY ./ ./

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
