# docker-node 22

node 22 基础环境（Debian 系，中国时区）：基座 `node:22-slim`（浮�?tag），预装 git / curl�?

- **canvas 运行时库**（`libcairo2 libpango-1.0-0 libjpeg62-turbo libgif7 librsvg2-2`）：
  只装**�?dev** 运行时包——node-canvas 自带 linux-x64-glibc prebuilt 二进制，
  项目�?`npm install canvas` �?prebuild-install 直接下载（无 g++ 也能用，
  国内网络可加 `--canvas_binary_host_mirror=https://registry.npmmirror.com/-/binary/canvas`�?
- npmmirror 注册�?+ 全局 `pnpm@latest`（npmmirror 源拉取）
- 时区�?`/etc/localtime` symlink + `/etc/timezone` 写入

**瘦身记录�?026-10�?*：老版本预装整条编译工具链（g++/make/autoconf/python3�? 整串
`-dev` 头文件包（unpacked ~230MB，仅用于源码编译场景）；canvas prebuilt 链路实测替代
后全部移除（本地绘制验证通过）。如确需本地编译原生模块（prebuilt 不可用的冷门包）�?
在业务镜像构建时自行 `apt-get install -y g++ make python3` 临时解决�?

- Docker Hub tag：`sxc654/docker-node:22`（`.github/workflows/docker-image.yml` 自动构建推送）

## 本地构建

```bash
cd node/22
docker build -t sxc654/docker-node:22 .
```

## 快速验�?

```bash
docker run --rm sxc654/docker-node:22 date         # 应为 CST（东八区�?
docker run --rm sxc654/docker-node:22 pnpm -v
docker run --rm sxc654/docker-node:22 node -e "require(\"canvas\")"   # 需业务里先 npm i canvas
```
