FROM nginx:stable

RUN apt update -y \
    && apt install -y certbot python3-certbot-nginx

RUN if ! crontab -l | grep -q "0 0 1 */1 * certbot renew -q"; then \
    (crontab -l ; echo "0 0 1 */1 * certbot renew -q") | crontab - ; \
fi

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
