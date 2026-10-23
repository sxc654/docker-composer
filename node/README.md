# node

node 基础环境镜像家族：**一个版本子目录 = 一个可独立构建的镜像** + 根 workflow matrix 一行，独立 tag 推送 Docker Hub，中国时区为基线。

## 约定

| 目录 | 基础镜像 | Docker Hub tag | 内容 |
|---|---|---|---|
| [`18/`](18/README.md) | `node:18-alpine3.19`（alpine 系，2024 起未更新） | `sxc654/docker-node:18` | apk 换 ustc 源 + 开发工具链：vim/git/g++/make/rsync/curl/autoconf/python3/openssh-client + tzdata → Asia/Shanghai |
| [`22/`](22/README.md) | `node:22-slim`（Debian 系，浮动 tag） | `sxc654/docker-node:22` | git/curl + canvas **运行时**库（libcairo2/libpango-1.0-0/libjpeg62-turbo/libgif7/librsvg2-2，prebuilt canvas 免编译）+ npmmirror + 全局 `pnpm` |
| [`nvm/`](nvm/README.md) | `debian:trixie-slim` + nvm v0.40.3 | `sxc654/docker-node:nvm` | 多版本运行时切换（预装 node 24+22，默认 24，npmmirror 下载，git/pnpm 基线） |

*（此表随成员增减维护，加一行即可）*

- **Docker Hub tag**：`sxc654/docker-node:<版本>`，版本目录即纯版本/变体名
  （`18`→`docker-node:18`、`22`→`docker-node:22`、`nvm`→`docker-node:nvm`），
  浮动基础 tag 跟随上游滚动更新
- **CI**：仓库根 `.github/workflows/docker-image.yml` 动态扫描发现，**新增版本/变体 = 建子目录 + README 表加行，workflow 零改动**；
  Secrets 复用仓库级 `DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`
- 基线内容（按需增减）：时区 Asia/Shanghai（Debian 系 symlink 写法 / alpine 系 tzdata 拷出写法）、
  npmmirror 注册表、全局 `pnpm`；canvas 依赖链仅在 Debian slim 系按需保留

## 快速上手（新增一个版本/变体）

1. 建 `<主版本>`（或 `<变体名>`，如 `nvm`）子目录：`Dockerfile`（FROM 用浮动官方 tag）+ `README.md`
   （内容取舍：照抄最近一个 Debian 系版本目录，改基座行即可）
2. 根 workflow **无需改动**（自动发现 + 前缀剥离推 tag）；只需要本 README 表加一行
3. 构建期自检建议写进 Dockerfile（缺件即构建失败）
4. push 即触发构建推送——退役则反向走一遍 + 本 README 历史注明；Hub 残留 tag 手动删

## 本地构建

```bash
cd node/18 && docker build -t sxc654/docker-node:18 .
cd node/22 && docker build -t sxc654/docker-node:22 .
cd node/nvm && docker build -t sxc654/docker-node:nvm .
```

## 整理说明（历史）

- 家族由原仓库 `sxc654/docker-node` subtree 合并而来，完整提交历史保留在对应 merge commit 的 parent 链里
- `node-14/` 已删除（无 Hub tag，无下游影响）
- 旧 `node-nvm/`（内嵌 node 14/17 旧版安装 + gcompat 硬凑 glibc 的本地实验）2026-10 删除后
  同月重建：新 `node-nvm/` 改 `debian:trixie-slim` + nvm v0.40.3 + node 24/22 双 LTS
  （alpine + gcompat 对 node>=16 实测不可行，本地验证见 nvm/README.md）
- `node-24/` 2026-10 由 22-slim 浮动化同日新建，同日被 node-nvm 覆盖集中管理而移除
  （镜像基线归入 node-nvm 的 node 24 预装；Hub 上早半天发布的 `docker-node:24` tag 已手动删除）
- node-22 基座曾固定在 `22.23.1-slim`，2026-10 起改浮动 `node:22-slim`，同月瘦身
  （移除编译工具链与 -dev 包，canvas 改 prebuilt 免编译，见 22/README.md）；目录名同步平铺为 `22/`
