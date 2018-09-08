FROM composer AS composer

# speedup
RUN composer global require hirak/prestissimo

COPY composer.json composer.lock ./
RUN composer install --no-autoloader

COPY . .
RUN composer dump-autoload


FROM node:8.11.4-alpine AS node

RUN apk add --no-cache \
    autoconf \
    automake \
    gcc \
    libc-dev \
    libpng-dev \
    libtool \
    make \
    nasm

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY public public
COPY resources resources
COPY webpack.mix.js .

ARG APP_ENV=prod

RUN if [ "${APP_ENV}" == "local" ]; then \
      npm run dev; \
    else \
      npm run prod; \
    fi


FROM php:7.2.8-fpm-alpine

ARG APP_ENV=prod

RUN set -xe; \
  apk add --no-cache \
    autoconf \
    gcc \
    libc-dev \
    libxslt-dev \
    make \
    shadow \
    ; \
  docker-php-ext-install opcache; \
  docker-php-ext-install pdo_mysql; \
  if [ "$APP_ENV" == "local" ]; then \
    pecl install xdebug-2.6.0; \
    docker-php-ext-enable xdebug; \
  fi;

COPY docker/php/conf.d/opcache.ini /usr/local/etc/php/conf.d/

ARG USER_ID=82

RUN usermod -u ${USER_ID} -o www-data
WORKDIR /var/www/html
RUN chown www-data:www-data /var/www/html
USER www-data

COPY --from=composer --chown=www-data:www-data /app/composer.lock ./
COPY --from=composer --chown=www-data:www-data /app/vendor ./vendor
COPY --from=node --chown=www-data:www-data /app/package-lock.json ./
COPY --from=node --chown=www-data:www-data /app/node_modules ./node_modules
COPY --chown=www-data:www-data . .

ENV PATH /var/www/html/vendor/bin:$PATH
