# docker-php 基础镜像 php-8.5
#
# 基于 php:8.5-fpm-alpine3.24（官方现值 8.5.12），扩展集与 basic/7.4 对齐
# （xdebug + mongodb + amqp + imagick + soap/pdo_mysql/mysqli/mbstring/zip/
#   bcmath/exif/intl/gd/pcntl）。
# ini 配置沿用 7.4/8.x 系的 xdebug.mode / client_port 体系（端口 9005，避开 php-fpm 9000）。
#
# 扩展安装沿用 PIE（PHP Installer for Extensions）——PECL 频道 REST 已弃用，
# PIE 是 PHP 官方继任安装器，从 packagist 解析版本。
# pie.phar 取自 PIE 1.5.3 稳定版发布物，vendor 在构建上下文 vendor/pie.phar。

FROM php:8.5-fpm-alpine3.24

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.24/main > /etc/apk/repositories \
    && echo http://mirrors.ustc.edu.cn/alpine/v3.24/community >> /etc/apk/repositories

# localtime（系统时区 + PHP 侧 date.timezone；PHP 不读 /etc/localtime，必须显式设置 ini）
RUN apk update \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && echo "date.timezone=Asia/Shanghai" > /usr/local/etc/php/conf.d/zz-timezone.ini

#******************vendor PIE（挂载使用，不进入镜像文件系统）******************
# RUN --mount=type=bind 不产生镜像层（COPY 会因跨层 rm 仍占 9MB）；pie.phar 仅构建期存在

# Install various PHP extensions（扩展集同 basic/7.4 + WordPress 常用扩展）
# 编译工具与 -dev 库放进 --virtual .build-deps（官方基础镜像不含工具链），编译完连同卸载
RUN --mount=type=bind,source=vendor/pie.phar,target=/tmp/pie.phar,ro \
    apk update \
    && apk add --no-cache \
        vim git rsync curl supervisor gcompat openssh-client mysql-client \
        icu-libs libxml2 openssl freetype libzip libpng libjpeg-turbo \
        oniguruma rabbitmq-c imagemagick libgomp \
        # libgomp：imagick.so（OpenMP）的运行期依赖，构建期随工具链安装，必须显式保留
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS autoconf libtool unzip linux-headers \
        icu-dev libxml2-dev openssl-dev freetype-dev libzip-dev libpng-dev libjpeg-turbo-dev \
        oniguruma-dev rabbitmq-c-dev imagemagick-dev \
    && docker-php-source extract \
    && php /tmp/pie.phar install --no-cache \
        xdebug/xdebug:3.5.3 \
        mongodb/mongodb-extension:2.5.5 \
        php-amqp/php-amqp:2.2.0 \
        imagick/imagick:3.8.1 \
    && docker-php-source delete \
    # Xdebug 3 配置：PIE 经 docker-php-ext-enable 生成此 ini，追加设置（Xdebug 3 已移除 remote_* 系列键）
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=no" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9005" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # mysqli/exif/intl/bcmath 为 WordPress 官方托管手册要求的扩展（intl 需 icu-dev，已装）
    && docker-php-ext-install soap pdo_mysql mysqli zip bcmath exif intl \
    # PHP 8.x 的 gd 配置不再接目录参数，pkg-config 自动定位
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl \
    # PHP 8.5 起 OPcache 内建并默认启用（php -m 直出 Zend OPcache），无需且不能显式 install：
    && apk del .build-deps

# 构建期自检：PIE 启用扩展是 best-effort（启用失败只 warn 不中断构建），故在此逐项断言；
# 缺扩展 / xdebug 配置未生效 / 时区不是 Asia/Shanghai 时，任一项失败即中断构建
RUN php -r '$required = ["xdebug","mongodb","amqp","imagick","soap","pdo_mysql","mysqli","mbstring","zip","bcmath","exif","intl","gd","pcntl","Zend OPcache"]; \
    $missing = []; \
    foreach ($required as $m) { if (!extension_loaded($m)) { $missing[] = $m; } } \
    if ($missing) { fwrite(STDERR, "missing extension: " . implode(", ", $missing) . PHP_EOL); exit(1); } \
    if (ini_get("xdebug.mode") !== "debug" || ini_get("xdebug.client_port") !== "9005") { fwrite(STDERR, "xdebug ini not applied" . PHP_EOL); exit(1); } \
    if (date_default_timezone_get() !== "Asia/Shanghai") { fwrite(STDERR, "date.timezone not applied: " . date_default_timezone_get() . PHP_EOL); exit(1); } \
    echo "extensions + xdebug ini OK" . PHP_EOL;'

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
