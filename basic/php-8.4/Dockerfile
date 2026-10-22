# docker-php 基础镜像 php-8.4
#
# 基于 php:8.4.27-fpm-alpine3.24，扩展集与 basic/php-7.4 保持一致
# （xdebug + mongodb + amqp + soap/pdo_mysql/mbstring/zip/gd/pcntl/opcache）。
# PHP 8.x 的 xdebug 必须用 3.x（7.4 用的 2.8.0 不支持 8.x），ini 配置也随之换成
# xdebug.mode / client_port 体系（端口沿用 8.2 旧镜像的 9005，避开 php-fpm 9000）。
#
# pecl 频道 REST 接口已弃用（"PECL is deprecated"），
# 故沿用 php-7.4 的做法：curl 从 pecl.php.net/get 直连下载 tgz 后本地安装，
# 不依赖 pecl 频道元数据解析。

FROM php:8.4.27-fpm-alpine3.24

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.24/main > /etc/apk/repositories \
    && echo http://mirrors.ustc.edu.cn/alpine/v3.24/community >> /etc/apk/repositories

# localtime
RUN apk update \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

# Install various PHP extensions（扩展集同 php-7.4）
RUN apk update \
    && apk add --no-cache vim git g++ make rsync curl autoconf supervisor gcompat openssh-client mysql-client \
    icu-dev icu-libs libxml2-dev openssl-dev freetype freetype-dev libzip libzip-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
    oniguruma oniguruma-dev rabbitmq-c rabbitmq-c-dev \
    && docker-php-source extract \
    && (pecl channel-discover pecl.php.net || pecl channel-update pecl.php.net) \
    && curl -fsSLo /tmp/xdebug-3.5.3.tgz https://pecl.php.net/get/xdebug-3.5.3 \
    && curl -fsSLo /tmp/mongodb-2.5.5.tgz https://pecl.php.net/get/mongodb-2.5.5 \
    && curl -fsSLo /tmp/amqp-2.2.0.tgz https://pecl.php.net/get/amqp-2.2.0 \
    && pecl install /tmp/xdebug-3.5.3.tgz /tmp/mongodb-2.5.5.tgz /tmp/amqp-2.2.0.tgz \
    && rm -f /tmp/xdebug-*.tgz /tmp/mongodb-*.tgz /tmp/amqp-*.tgz \
    && docker-php-ext-enable xdebug mongodb amqp \
    && docker-php-source delete \
    # Xdebug 3 配置（Xdebug 3 已移除 remote_* 系列键）
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=no" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9005" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && docker-php-ext-install soap pdo_mysql mbstring zip \
    # PHP 8.x 的 gd 配置不再接目录参数，pkg-config 自动定位
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache \
    && apk del --no-cache libxml2-dev openssl-dev freetype-dev libzip-dev libpng-dev libjpeg-turbo-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
