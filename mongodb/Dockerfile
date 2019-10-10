FROM sxc654/docker-composer:php7.1
RUN apk update && apk add --no-cache \
    libressl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb