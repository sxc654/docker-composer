FROM alpine:3.22

# 时区（上海）+ 编码 UTF-8（中文必备）
ENV TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    JAVA_OPTS="-Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"

# ==================== 换源 + 安装依赖 ====================
RUN sed -i 's|https://dl-cdn.alpinelinux.org|https://mirrors.nju.edu.cn|g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
        tzdata \
        font-adobe-100dpi \
        ttf-dejavu \
        fontconfig \
        busybox \
        libmcrypt \
        libmcrypt-dev \
        curl \
        git \
        make \
        openssh-client \
        autoconf \
        supervisor \
        openjdk17 \
        openjdk17-jdk \
        openjdk17-jmods \
        openjdk17-demos \
        openjdk17-doc \
        openjdk17-jre-headless \
        openjdk17-jre \
        java-common \
        java-cacerts \
        python3 \
        python3-dev \
        py3-pip && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
