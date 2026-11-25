FROM node:22.21.1-alpine3.23 AS frontend-builder
WORKDIR /app
RUN apk upgrade --no-cache && rm -rf /var/cache/apk/*
COPY laravel/package.json laravel/package-lock.json ./
RUN npm ci && npm cache clean --force
COPY laravel/ .
RUN npm run build

FROM composer:2.9.2 AS vendor-builder
WORKDIR /app
COPY laravel/composer.json laravel/composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

FROM php:8.5.4-fpm-alpine3.23 AS production
WORKDIR /var/www/html

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        libpng-dev \
        libzip-dev \
        postgresql-dev \
    && docker-php-ext-install pdo_pgsql zip gd \
    && rm -rf /var/cache/apk/*

COPY --from=vendor-builder /app/vendor /var/www/html/vendor
COPY laravel/ /var/www/html
COPY --from=frontend-builder /app/public/build /var/www/html/public/build

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
USER www-data
