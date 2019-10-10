FROM sxc654/docker-composer:php7.1
RUN apk add \
    libressl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb