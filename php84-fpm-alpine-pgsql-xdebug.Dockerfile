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
  pcre-dev \
  icu-dev \
  vips \
  vips-dev \
  linux-headers \
  autoconf

RUN docker-php-ext-configure gd \
  --with-freetype \
  --with-jpeg \
  --with-webp

RUN docker-php-ext-install -j$(nproc) \
  gd \
  gmp \
  pdo_pgsql \
  mbstring \
  pdo \
  sockets \
  sodium \
  bcmath \
  zip \
  intl \
  pcntl \
  exif \
  ffi

RUN pecl install \
  xdebug \
  ds

RUN docker-php-ext-enable \
  xdebug \
  opcache \
  ds \
  ffi

RUN printf "ffi.enable=true\nzend.max_allowed_stack_size=-1\n" \
  > /usr/local/etc/php/conf.d/ffi.ini

RUN curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin \
  --filename=composer

FROM php:8.4-fpm-alpine

WORKDIR /app

COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer

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
  pcre \
  postgresql-libs \
  postgresql-client \
  icu \
  tzdata \
  vips \
  vips-dev \
  && echo 'America/Sao_Paulo' > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
  && rm -rf /var/cache/apk/*

ENV LD_LIBRARY_PATH=/usr/lib:/lib

EXPOSE 9000

CMD ["php-fpm"]