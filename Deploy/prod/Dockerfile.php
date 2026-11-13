FROM composer:2.7 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

FROM php:8.5-fpm-alpine AS production
WORKDIR /var/www/html

RUN apk add --no-cache \
    libpng-dev \
    libzip-dev \
    postgresql-dev \
    && docker-php-ext-install pdo_pgsql zip gd \
    && rm -rf /var/cache/apk/*

COPY --from=vendor /app/vendor /var/www/html/vendor
COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
USER www-data
