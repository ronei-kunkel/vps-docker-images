FROM nginx:stable-alpine

RUN apk add certbot-nginx

COPY ./.docker/nginx/crontab.sh /crontab.sh

RUN chmod +x /crontab.sh

RUN /crontab.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
