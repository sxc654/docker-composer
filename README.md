# docker-node

node 基础环境镜像集中维护仓库：**一个版本子目录 = 一个可独立构建的镜像** +
一段 CI matrix 条目，独立 tag 推送 Docker Hub，中国时区为基线。

## 约定

```text
node-<主版本>/        # 一版本一目录：Dockerfile + README.md（可选其他依赖物）
```

- **Docker Hub tag**：`sxc654/docker-node:<主版本>`，浮动基础 tag（如 `node:2?-slim`）
  跟随上游滚动更新
- **CI**：`.github/workflows/docker-image.yml` matrix 显式列出版本号，每版本独立
  buildx + GHA 缓存并行构建；Secrets 复用 `DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`
- 基线内容（按需增减）：时区 Asia/Shanghai（Debian 系 symlink 写法 / alpine 系 tzdata 拷出
  写法）、npmmirror 注册表、全局 `pnpm`；canvas 依赖链仅在 Debian slim 系按需保留

## 当前版本（随增减维护的快照）

| 目录 | 基础镜像 | Docker Hub tag | 内容 |
|---|---|---|---|
| [`node-18/`](node-18/README.md) | `node:18-alpine3.19`（alpine 系，2024 起未更新） | `sxc654/docker-node:18` | apk 换 ustc 源 + 开发工具链：vim/git/g++/make/rsync/curl/autoconf/python3/openssh-client + tzdata → Asia/Shanghai |
| [`node-22/`](node-22/README.md) | `node:22-slim`（Debian 系，浮动 tag） | `sxc654/docker-node:22` | apt 装 git/g++/make/autoconf/python3/curl + canvas 依赖链（libcairo2/libpango/libjpeg/libgif/librsvg dev）+ 全局 `pnpm` |
| [`node-24/`](node-24/README.md) | `node:24-slim`（Debian 系，浮动 tag） | `sxc654/docker-node:24` | 与 node-22 同款内容，新版 LTS 基座 |

## 快速上手（新增一个版本）

1. 建 `node-<主版本>/` 子目录：`Dockerfile`（FROM 用浮动官方 tag）+ `README.md`
   （内容取舍：照抄最近一个 Debian 系版本目录，改基座行即可）
2. workflow matrix 加一行 `- version: <主版本>`（tag 自动推导 `docker-node:<主版本>`）
3. 根 README 本表和 `node-<主版本>/README.md` 加一行
4. 构建内容有自检需求就写进 Dockerfile（参考 composer 家族做法）
5. push 即触发构建推送——版本退役则反向走一遍 + README 历史说明注明

## 本地构建

```bash
cd node-18 && docker build -t sxc654/docker-node:18 .
cd node-22 && docker build -t sxc654/docker-node:22 .
cd node-24 && docker build -t sxc654/docker-node:24 .
```

## 整理说明（历史）

- `node-14/` 与 `node-nvm/`（内嵌 node 14/17 旧版安装的本地实验产物）已删除，均无 Hub tag，无下游影响
- node-22 基座曾固定在 `22.23.1-slim`，2026-10 起改浮动 `node:22-slim`
