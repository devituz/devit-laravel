FROM php:8.3.20-fpm AS builder

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       lsb-release \
       ca-certificates \
       curl \
       git \
       unzip \
       libpq-dev \
       libzip-dev \
       libicu-dev \
       libonig-dev \
       libxml2-dev \
       libjpeg-dev \
       libpng-dev \
       libfreetype6-dev \
       libmagickwand-dev \
       libcurl4-openssl-dev \
       pkg-config \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) \
       pdo_pgsql \
       mbstring \
       xml \
       zip \
       curl \
       bcmath \
       intl \
       gd \
  && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

FROM php:8.3.20-fpm

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libpq5 \
      libzip4 \
      libjpeg62-turbo \
      libpng16-16 \
      libfreetype6 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 777 storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
