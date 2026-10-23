# docker-node

node 基础环境镜像（中国时区）：18、22 两个版本，随家族约定各占一个子目录，
push 到 master 后 GitHub Actions 自动构建并推送 Docker Hub（`docker-image.yml` matrix 两 job 并行）。

## 版本

| 目录 | 基础镜像 | Docker Hub tag | 内容 |
|---|---|---|---|
| [`node-18/`](node-18/README.md) | `node:18-alpine3.19`（alpine 系） | `sxc654/docker-node:18` | apk 换 ustc 源 + 开发工具链：vim/git/g++/make/rsync/curl/autoconf/python3/openssh-client + tzdata → Asia/Shanghai |
| [`node-22/`](node-22/README.md) | `node:22.23.1-slim`（Debian 系） | `sxc654/docker-node:22` | apt 装 git/g++/make/autoconf/python3/curl + canvas 依赖链（libcairo2/libpango/libjpeg/libgif/librsvg dev）+ npmmirror 注册表 + 全局 `pnpm` |

## CI

`.github/workflows/docker-image.yml`：matrix 显式列出 18、22 两个版本，各自独立 buildx + GHA 缓存，
tag 固定推导为 `docker-node:<版本>`；Secrets：`DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`。

## 本地构建

```bash
cd node-18 && docker build -t sxc654/docker-node:18 .
cd node-22 && docker build -t sxc654/docker-node:22 .
```

## 快速验证

```bash
docker run --rm sxc654/docker-node:18 date                       # CST（东八区）
docker run --rm sxc654/docker-node:18 node -v
docker run --rm sxc654/docker-node:22 node -e "require('canvas')" # canvas 可用性
docker run --rm sxc654/docker-node:22 pnpm -v
```
