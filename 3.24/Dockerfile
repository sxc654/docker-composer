# docker-alpine
#
# 基于 alpine:3.24，GitLab CI 部署镜像：
# openssh-client（ssh/ssh-agent/ssh-add）+ rsync + git + bash。
# alpine busybox 自含标准工具集（sh/cp/mv/find 等均可用）。
# 时区 Asia/Shanghai：/etc/localtime 必须由 tzdata 拷出，拷完即卸 tzdata（运行期不需要 zoneinfo 数据库）。

FROM alpine:3.24

#******************更换Alpine源为mirrors.ustc.edu.cn******************
RUN echo http://mirrors.ustc.edu.cn/alpine/v3.24/main > /etc/apk/repositories \
    && echo http://mirrors.ustc.edu.cn/alpine/v3.24/community >> /etc/apk/repositories

RUN apk add --no-cache \
        openssh-client \
        rsync \
        git \
        bash \
        ca-certificates \
        tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

# 构建期自检：工具必须可用 + 时区正确，任一项失败即中断构建
RUN date +%Z | grep -q '^CST$' \
    && bash -c 'ssh -V 2>&1 && rsync --version | head -1 && git --version && tar --version | head -1 && ls /etc/localtime'

CMD ["bash"]
