FROM node:14.17 as react-build

WORKDIR /app
COPY package*.json ./

RUN npm install
COPY . ./

RUN npm run build

# server environment
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template

# Change '/app/dist' to '/app/build'
COPY --from=react-build /app/build /usr/share/nginx/html

ENV PORT 3000
ENV HOST 0.0.0.0
EXPOSE 3000
CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
