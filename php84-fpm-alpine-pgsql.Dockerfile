FROM php:8.4-fpm-alpine AS builder

WORKDIR /app

RUN apk --no-cache add \
  build-base \
  openssl \
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
  pcre-dev \
  # bzip2-dev \
  icu-dev \
  autoconf

RUN docker-php-ext-configure gd \
  --with-freetype=/usr/include/ \
  --with-jpeg=/usr/include/ \
  --with-webp=/usr/include/

RUN docker-php-ext-install -j$(nproc) \
  gd \
  gmp \
  pdo_pgsql \
  mbstring \
  pdo \
  # exif \
  sockets \
  sodium \
  bcmath \
  zip \
  intl \
  # bz2 \
  pcntl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

FROM php:8.4-fpm-alpine

WORKDIR /app

COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer

RUN apk --no-cache add \
  freetype \
  libjpeg-turbo \
  libpng \
  libwebp \
  libzip \
  zlib \
  oniguruma \
  gmp \
  libsodium \
  pcre \
  bzip2 \
  icu \
  tzdata \
  && echo 'America/Sao_Paulo' > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
  && rm -rf /var/cache/apk/*

EXPOSE 9000

CMD ["php-fpm"]
