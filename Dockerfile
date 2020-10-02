FROM node:14.12.0-alpine@sha256:24ed8df3382733b7be4e3c9d592d3f5e7ed3939a27dd5e50a43c181e299478df AS production

WORKDIR /srv/app/

COPY ./ ./

RUN yarn install

EXPOSE 8080

ENTRYPOINT ["node", "./src/generator.js"]
