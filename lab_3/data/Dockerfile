FROM node:16-alpine
ADD ./nestjs-rest-api/package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /usr/app && cp -a /tmp/node_modules /usr/app/

WORKDIR /usr/app
ADD ./nestjs-rest-api /usr/app

RUN npm run build

WORKDIR /usr/app/dist
EXPOSE 3000
CMD ["node", "main.js"]