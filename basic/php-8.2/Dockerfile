FROM php:8.2-fpm-alpine3.19

# Alpine源
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.19/main > /etc/apk/repositories && \
    echo http://mirrors.ustc.edu.cn/alpine/v3.19/community >> /etc/apk/repositories

# Install dependencies
RUN apk update \
    && apk add --no-cache \
    autoconf \
    make \
    g++ \
    gcc \
    vim \
    rsync \
    curl \
    supervisor \
    linux-headers \
    openssh-client \
    postgresql-client \
    mysql-client \
    tzdata \
    freetype \
    icu-libs \
    libbz2 \
    libc6-compat \
    libjpeg-turbo \
    libpng \
    libwebp \
    libxml2 \
    libzip \
    rabbitmq-c \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/cache/apk/*

# Install various PHP extensions
RUN apk add --no-cache --virtual .build-deps \
    icu-dev \
    icu-libs \
    libzip-dev \
    openssl-dev \
    libxml2-dev \
    libpng-dev \
    libwebp-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    postgresql-dev \
    rabbitmq-c-dev \
    oniguruma-dev \
    && docker-php-source extract \
    # PECL Extensions
    && pecl install xdebug-3.3.0 && docker-php-ext-enable xdebug \
    && pecl install mongodb-1.17.0 && docker-php-ext-enable mongodb \
    && pecl install amqp-2.1.1 && docker-php-ext-enable amqp \
    && pecl install redis-6.0.0 && docker-php-ext-enable redis \
    && docker-php-source delete \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=no" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9005" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=false" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # Install PHP extension
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install gd pcntl mbstring zip soap pdo_mysql pdo_pgsql opcache \
    # Cleanup
    && apk del .build-deps 


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# # Install PHP-CS-FIXER
# RUN wget https://cs.symfony.com/download/php-cs-fixer-v3.phar -O php-cs-fixer \
#     && chmod a+x php-cs-fixer \
#     && php-cs-fixer /usr/local/bin/php-cs-fixe
