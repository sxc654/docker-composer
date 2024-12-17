FROM php:8.2-fpm-alpine3.19

# Alpine源
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.19/main > /etc/apk/repositories && \
    echo http://mirrors.ustc.edu.cn/alpine/v3.19/community >> /etc/apk/repositories

# Install Timezone
RUN apk update \
    && apk add --no-cache \
    make \
    g++ \
    vim \
    rsync \
    curl \
    supervisor \
    linux-headers \
    openssh-client \
    tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del \
    && rm -rf /var/cache/apk/*

# Install various PHP extensions
RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    icu-dev \
    icu-libs \
    libxml2-dev \
    freetype-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    oniguruma-dev \
    postgresql-dev \
    rabbitmq-c-dev \
    # Install PHP extension
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install gd \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install soap \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install opcache \
    && docker-php-source extract \
    # PECL Extensions
    && pecl install xdebug-3.3.0 \
    && pecl install mongodb-1.17.0 \
    && pecl install amqp \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-enable amqp \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && docker-php-source delete \
    # Cleanup
    && apk del .build-deps 

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
