FROM roneikunkel/php82-fpm-alpine:latest

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions uopz

CMD sh -c "php-fpm"
