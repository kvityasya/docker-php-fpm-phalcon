FROM php:7.4-fpm-alpine

LABEL Maintainer="Viktor Kolotiy <kvityasy@gmail.com>" \
  Description="PHP-FPM 7.4 PHALCON 4.0.5"

RUN apk update

# Install packages
RUN set -eux \
 && apk add --update --no-cache git autoconf g++ libtool make libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev tzdata \
 && pecl install redis \
 && docker-php-ext-configure gd --with-jpeg=/usr \
 && docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-install opcache bcmath pdo_mysql mysqli gd exif zip \
 && docker-php-ext-enable redis

# Install telnet
RUN apk add --no-cache busybox-extras

# Install intl
RUN apk add --no-cache icu-dev
RUN docker-php-ext-configure intl \
  && docker-php-ext-install intl

# Install sockets
RUN set -eux \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sockets

# Install xsl
RUN apk add --no-cache libxslt-dev
RUN docker-php-ext-configure xsl \
  && docker-php-ext-install xsl

# Install imagick
RUN apk add --no-cache --no-progress imagemagick-dev \
  && apk add --no-cache --no-progress imagemagick \
  && pecl install imagick \
  && docker-php-ext-enable imagick

# Install psr
RUN set -eux \
  && pecl install psr-1.0.0 \
  && docker-php-ext-enable psr

# Install phalcon    
RUN set -eux \
  && pecl install phalcon-4.0.5 \
  && docker-php-ext-enable phalcon

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install supervisor
RUN apk update &&  apk add --no-cache supervisor

# cleanup
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*