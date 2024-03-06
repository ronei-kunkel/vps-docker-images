FROM nginx:stable

RUN apt-get update \
    && apt-get install -y software-properties-common gnupg \
    && echo "deb http://ppa.launchpad.net/certbot/certbot/ubuntu bionic main" > /etc/apt/sources.list.d/certbot.list \
    && add-apt-repository ppa:certbot/certbot \
    && apt-get update

RUN apt install certbot-nginx

RUN if ! crontab -l | grep -q "0 0 1 */1 * certbot renew -q"; then \
    (crontab -l ; echo "0 0 1 */1 * certbot renew -q") | crontab - ; \
fi

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
