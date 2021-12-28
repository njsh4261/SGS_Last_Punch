# base image
FROM node:17.3.0-alpine

# set working directory
WORKDIR /app

# `/app/node_modules/.bin`을 $PATH 에 추가
ENV PATH /app/node_modules/.bin:$PATH

# app dependencies, install 및 caching
COPY package.json /app/package.json
RUN npm install
RUN npm install react-scripts@3.0.1 -g

# 앱 실행
CMD ["npm", "start"]