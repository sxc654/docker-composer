# docker-node 22

node 22 基础环境（Debian 系，中国时区）：基础 `node:22.23.1-slim`，
预装 git / g++ / make / autoconf / python3 / curl。

- canvas 依赖链（`libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev`）：
  node:22-slim 基座直接预装 dev 依赖，项目里 `npm install canvas` / `require('canvas')` 免编译等待
- npmmirror 注册表 + 全局 `pnpm@latest`

- Docker Hub tag：`sxc654/docker-node:22`（`.github/workflows/docker-image.yml` 自动构建推送）
- 时区由 `/etc/localtime` symlink + `/etc/timezone` 写入（Debian 系，apt 不装 tzdata 包）

## 本地构建

```bash
cd node-22
docker build -t sxc654/docker-node:22 .
```

## 快速验证

```bash
docker run --rm sxc654/docker-node:22 date                        # 应为 CST（东八区）
docker run --rm sxc654/docker-node:22 node -e "require('canvas')" # 无报错即 canvas 原生编译通过
docker run --rm sxc654/docker-node:22 pnpm -v
```
