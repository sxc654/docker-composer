FROM sxc654/docker-composer:php7.1
RUN apk add \
    libressl-dev \
    imap-dev \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install imap