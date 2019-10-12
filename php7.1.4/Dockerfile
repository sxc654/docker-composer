FROM php:7.1.4-fpm-alpine

RUN apk update && apk add --no-cache \
    git \
    mysql-client \
    curl \
    libmcrypt \
    libmcrypt-dev \
    openssh-client \
    rsync \
    icu-dev \
    libxml2-dev \
    freetype \
    freetype-dev \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    g++ \
    make \
    autoconf \
    supervisor \

RUN docker-php-source extract \
    && pecl install xdebug redis opcache\
    && docker-php-ext-enable xdebug redis opcache\
    && docker-php-source delete \
    && docker-php-ext-install mcrypt pdo_mysql soap \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm -rf /tmp/*

RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install gd \
      && apk del --no-cache freetype freetype-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
      && rm -rf /tmp/*