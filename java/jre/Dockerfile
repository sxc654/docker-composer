FROM alpine:edge

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/latest-stable/main > /etc/apk/repositories && \
    echo http://mirrors.ustc.edu.cn/alpine/latest-stable/community >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache openjdk8-jre-base busybox libmcrypt libmcrypt-dev curl openssh-client supervisor tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone 