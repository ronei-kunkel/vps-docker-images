FROM php:8.4-fpm-alpine AS builder

WORKDIR /app

RUN apk add --no-cache \
  $PHPIZE_DEPS \
  freetype-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libwebp-dev \
  libzip-dev \
  zlib-dev \
  oniguruma-dev \
  gmp-dev \
  libsodium-dev \
  postgresql-dev \
  icu-dev \
  linux-headers

RUN docker-php-ext-configure gd \
  --with-freetype \
  --with-jpeg \
  --with-webp

  RUN docker-php-ext-install -j$(nproc) \
  gd \
  gmp \
  pdo_pgsql \
  mbstring \
  sockets \
  sodium \
  bcmath \
  zip \
  intl \
  pcntl

RUN pecl install ds

RUN docker-php-ext-enable \
  opcache \
  ds

RUN rm -rf /tmp/pear

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

FROM php:8.4-fpm-alpine

WORKDIR /app

COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache \
  freetype \
  libjpeg-turbo \
  libpng \
  libwebp \
  libzip \
  zlib \
  oniguruma \
  gmp \
  libsodium \
  postgresql-libs \
  postgresql-client \
  icu \
  tzdata

RUN echo "America/Sao_Paulo" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

EXPOSE 9000

CMD ["php-fpm"]
