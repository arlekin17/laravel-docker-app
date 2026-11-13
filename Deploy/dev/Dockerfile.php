FROM php:8.5-fpm-alpine

RUN apk add --no-cache \
    libpng-dev \
    libzip-dev \
    postgresql-dev \
    git \
    unzip \
    && docker-php-ext-install pdo_pgsql zip gd \
    && rm -rf /var/cache/apk/*

WORKDIR /var/www/html
