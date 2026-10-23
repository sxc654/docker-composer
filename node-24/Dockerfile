FROM node:24-slim

# Debian 系用 apt，不是 apk
RUN apt-get update && apt-get install -y --no-install-recommends \
    git g++ make autoconf python3 curl \
    libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

RUN npm config set registry https://registry.npmmirror.com \
    && npm install -g pnpm@latest
