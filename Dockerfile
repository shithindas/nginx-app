FROM node:14
LABEL maintainer="shithindasmk@gmail.com"

#Creating app directory
RUN mkdir -p /app
WORKDIR /app

#Copies package.json
COPY package.json /app

#Install NPM modules
RUN npm install

#Copies source code
COPY . /app

EXPOSE 3000

CMD [ "npm", "start" ]
