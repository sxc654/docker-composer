# docker-php 基础镜像 php-7.4（CVE-2026-109618 / CVE-2026-109619 安全修复版）
#
# 背景（2026-10-21 PHP 安全公告，CVSS v4.0 9.2，未认证 RCE）：
#   CVE-2026-109618 (GHSA-w8hw-w9fx-j79w) OOM 处理打断请求初始化，
#     请求清理将未初始化/残留内存当作有效数据使用；
#   CVE-2026-109619 (GHSA-6wmf-4rv5-p3rp) 请求态内存在释放后仍被
#     同 worker 的下一个请求消费（stale global state）。
#   PHP 7.4 已 EOL 无官方二进制版本；PHP 安全团队为 7.4 分支发布了
#   官方最小源码 backport（唯一权威修复来源）：
#     分支: PHP-7.4-CVE-2026-109618-109619
#     提交: 712e60f9edfd03f0960fc4fc3c2c375f42b90aa2
#
# 构建方式：基础镜像从 php:7.4-fpm-alpine3.12（停在 7.4.20）升级到官方
# 7.4 最终构建 php:7.4-fpm-alpine3.16（PHP 7.4.33），COPY 官方补丁
# （已 vendor 至 patches/，sha256 见下）后按官方同款 configure 参数
# 原位重编译 PHP，其余扩展/工具链保持不变。
#
# 补丁校验（构建不做校验，仅此备案；如需可在构建前自行核对）：
#   sha256: d059c1b4ea0f9023a1e1c17f6eddee82e3c2e029c60dd0a08fc5466764b5eaa4
#   来源:   https://github.com/php/php-src/commit/712e60f9edfd03f0960fc4fc3c2c375f42b90aa2.diff

FROM php:7.4-fpm-alpine3.16

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.16/main > /etc/apk/repositories \
    && echo http://mirrors.ustc.edu.cn/alpine/v3.16/community >> /etc/apk/repositories

# localtime
RUN apk update \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone 

#*****************************************************************************
# 应用官方安全补丁并原位重编译 PHP 7.4.33
# configure 参数复制自 docker-library/php 7.4.33-alpine3.16 官方构建，
# 保证 ABI/加载路径/扩展目录与官方镜像完全一致
#*****************************************************************************
COPY patches/php-7.4-CVE-2026-109618-109619.patch /usr/src/

RUN set -eux; \
    apk add --no-cache --virtual .php-rebuild-deps \
        autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
        coreutils argon2-dev curl-dev gnu-libiconv-dev libsodium-dev libxml2-dev \
        linux-headers oniguruma-dev openssl-dev readline-dev sqlite-dev \
        patch; \
    docker-php-source extract; \
    cd /usr/src/php; \
    # 补丁必须完整应用，出现任何 reject 直接失败
    patch -p1 -N < /usr/src/php-7.4-CVE-2026-109618-109619.patch; \
    # 断言补丁关键改动已进入源码
    grep -q 'zend_mm_safe_error_ex' Zend/zend_alloc.c; \
    grep -q 'zend_new_array_singleton' Zend/zend_API.h; \
    # 官方镜像同款：musl iconv 不完整，链接 gnu-libiconv（基础镜像里已有旧链接，-f 覆盖）
    rm -fv /usr/include/iconv.h; \
    ln -svf /usr/include/gnu-libiconv/*.h /usr/include/; \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-option-checking=fatal \
        --with-mhash \
        --with-pic \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-password-argon2 \
        --with-sodium=shared \
        --with-pdo-sqlite=/usr \
        --with-sqlite3=/usr \
        --with-curl \
        --with-iconv=/usr \
        --with-openssl \
        --with-readline \
        --with-zlib \
        --disable-phpdbg \
        --with-pear \
        $(test "$gnuArch" = 's390x-linux-musl' && echo '--without-pcre-jit') \
        --disable-cgi \
        --enable-fpm \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
    ; \
    make -j "$(nproc)"; \
    find -type f -name '*.a' -delete; \
    make install; \
    find /usr/local -type f \
        -perm '/0111' \
        -exec sh -euxc ' strip --strip-all "$@" || : ' -- '{}' +; \
    make clean; \
    docker-php-source delete; \
    apk del .php-rebuild-deps; \
    # 编译后冒烟测试
    php --version; \
    php -m

#
# 缓解配置（纵深防御；conf.d 级配置无法被应用层 ini_set() / .user.ini 覆盖。
# 注意：这只是补充，真正的修复是上面打补丁重编译的 PHP 本体）
#
RUN printf 'session.upload_progress.enabled = 0\n' \
    > /usr/local/etc/php/conf.d/zz-security-php2shell.ini

# Install various PHP extensions
RUN apk update \
    && apk add --no-cache vim git g++ make rsync curl autoconf supervisor gcompat openssh-client mysql-client \
    icu-dev icu-libs libxml2-dev openssl-dev freetype freetype-dev libzip libzip-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
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
    && apk del --no-cache libxml2-dev openssl-dev freetype-dev libzip-dev libpng-dev libjpeg-turbo-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
