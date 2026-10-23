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
        fontconfig \
        ttf-dejavu \
        wqy-zenhei \
        openjdk21-jre-headless && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
