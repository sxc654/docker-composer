FROM php:7.1-fpm-alpine
RUN apk --update add --no-cache git bash openssh-client freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install gd  \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev  \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer