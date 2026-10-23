FROM debian:trixie-slim

ENV NVM_DIR=/root/.nvm \
    NVM_VERSION=v0.40.3 \
    NVM_SYMLINK_CURRENT=true \
    NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node \
    NVM_IOJS_ORG_MIRROR=https://npmmirror.com/mirrors/iojs

# bash 是 nvm 的硬依赖；curl/gitee 拉包 + npmmirror 装 node 二进制（全程避开 github 直连）
# 注意：不用 alpine 基座——官方 node 二进制是 glibc 的，musl 下 gcompat 兼容层对 node>=16
# 直接 reloc 崩溃（本地已实测），debian slim 是 glibc 系里最小的可用基座
RUN sed -i 's|http://deb.debian.org|http://mirrors.ustc.edu.cn|g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
      bash curl ca-certificates tzdata git \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

# nvm 本体：gitee 镜像 v0.40.3；交互 shell 经 /root/.bashrc 加载，登录 shell 经 /etc/profile.d 加载，
# 非交互进程靠下面的 PATH(current/bin) 兜底
RUN curl -fsSL "https://gitee.com/mirrors/nvm/repository/archive/${NVM_VERSION}.tar.gz" -o /tmp/nvm.tar.gz \
    && tar xzf /tmp/nvm.tar.gz -C /tmp \
    && rm /tmp/nvm.tar.gz \
    && mv "/tmp/nvm-${NVM_VERSION}" "${NVM_DIR}" \
    && echo 'export NVM_DIR="/root/.nvm"' > /etc/profile.d/nvm.sh \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /etc/profile.d/nvm.sh \
    && echo '' >> /root/.bashrc \
    && echo 'export NVM_DIR="/root/.nvm"' >> /root/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /root/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"' >> /root/.bashrc

# 装 LTS 双版本：默认 24，备 22；npmmirror 镜像下载
RUN bash -c 'set -e; \
    . "$NVM_DIR/nvm.sh"; \
    nvm install 24; \
    nvm install 22; \
    nvm alias default 24; \
    nvm use default >/dev/null; \
    node -v; npm -v; \
    npm config set registry https://registry.npmmirror.com; \
    npm install -g pnpm@latest; \
    rm -rf "$NVM_DIR/.cache"'

# /root/.nvm/current 由 NVM_SYMLINK_CURRENT 维护（nvm use 时同步翻新），非交互进程靠它访问 node/npm
ENV PATH="/root/.nvm/current/bin:${PATH}"

CMD ["bash"]
