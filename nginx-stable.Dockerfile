FROM nginx:stable

RUN apt update \
    && apt install snapd \
    && snap install --classic certbot \
    && ln -s /snap/bin/certbot /usr/bin/certbot

RUN if ! crontab -l | grep -q "0 0 1 */1 * certbot renew -q"; then \
    (crontab -l ; echo "0 0 1 */1 * certbot renew -q") | crontab - ; \
fi

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
