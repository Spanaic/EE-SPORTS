FROM node:12.11.1-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

ENV HOST 0.0.0.0
EXPOSE 3000
