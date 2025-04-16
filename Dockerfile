FROM php:8.2-fpm

ARG WWWGROUP


RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev \
    libzip-dev libpq-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-install pdo pdo_pgsql zip gd


COPY --from=composer:2 /usr/bin/composer /usr/bin/composer


RUN groupadd -g ${WWWGROUP} devituz \
    && useradd -u 1337 -g devituz -m devituz \
    && chown -R devituz:devituz /var/www

WORKDIR /var/www/html

USER devituz
