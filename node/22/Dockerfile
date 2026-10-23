FROM node:22-slim

# Debian 源换 USTC（本地网络 deb.debian.org 不通；CI 从 GitHub 动 runner 同样可走 ustc）
RUN find /etc/apt -name "*.sources" -exec sed -i "s|http://deb.debian.org|http://mirrors.ustc.edu.cn|g" {} + \
    && apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates \
      libcairo2 libpango-1.0-0 libjpeg62-turbo libgif7 librsvg2-2 \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN npm config set registry https://registry.npmmirror.com \
    && npm install -g --no-audit --no-fund pnpm@latest \
    && npm cache clean --force \
    && rm -rf /root/.npm /tmp/*
