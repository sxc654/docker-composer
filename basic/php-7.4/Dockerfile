FROM php:7.4-fpm-alpine3.12

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.12/main > /etc/apk/repositories \
    && echo http://mirrors.ustc.edu.cn/alpine/v3.12/community >> /etc/apk/repositories

# localtime
RUN apk update \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone 

# Install various PHP extensions
RUN apk update \
    && apk add --no-cache vim git g++ make rsync curl autoconf supervisor openssh-client mysql-client\
    icu-dev icu-libs libxml2-dev libressl libressl-dev freetype freetype-dev libzip libzip-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
    oniguruma oniguruma-dev rabbitmq-c rabbitmq-c-dev \
    && docker-php-source extract \
    && pecl install xdebug-2.8.0 mongodb-1.16.1 amqp \
    && docker-php-ext-enable xdebug mongodb amqp \
    && docker-php-source delete \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && docker-php-ext-install soap pdo_mysql mbstring zip\
    && docker-php-ext-configure gd \
    --with-jpeg=/usr/include/ \
    --with-freetype=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache \
    && apk del --no-cache libxml2-dev libressl-dev freetype-dev libzip-dev libpng-dev libjpeg-turbo-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
