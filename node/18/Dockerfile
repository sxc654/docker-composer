FROM node:18-alpine3.19

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.19/main > /etc/apk/repositories \
    && echo http://mirrors.ustc.edu.cn/alpine/v3.19/community >> /etc/apk/repositories

# localtime
RUN apk update \
    && apk add --no-cache vim git g++ make rsync curl autoconf python3 openssh-client tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone 
