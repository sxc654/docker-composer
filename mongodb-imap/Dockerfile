FROM sxc654/docker-composer:mongodb
RUN apk update && apk add --no-cache \
    imap-dev \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install imap