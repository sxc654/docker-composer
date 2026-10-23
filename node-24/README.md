# docker-node 24

node 24 基础环境（Debian 系，中国时区）：基础 `node:24-slim`（浮动 tag 跟随官方 24.x 更新），
预装 git / g++ / make / autoconf / python3 / curl。

- canvas 依赖链（`libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev`）：
  prebuilt 不可用时 `npm install canvas` 免编译等待，dev 依赖已就位
- npmmirror 注册表 + 全局 `pnpm@latest`
- Docker Hub tag：`sxc654/docker-node:24`（`.github/workflows/docker-image.yml` 自动构建推送）
- 时区由 `/etc/localtime` symlink + `/etc/timezone` 写入（Debian 系，apt 不装 tzdata 包）

## 本地构建

```bash
cd node-24
docker build -t sxc654/docker-node:24 .
```

## 快速验证

```bash
docker run --rm sxc654/docker-node:24 date                        # 应为 CST（东八区）
docker run --rm sxc654/docker-node:24 node -v                    # v24.x
docker run --rm sxc654/docker-node:24 node -e "require('canvas')" # 无报错即 canvas 编译链可用
docker run --rm sxc654/docker-node:24 pnpm -v
```
