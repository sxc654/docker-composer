# docker-node 18

node 18 基础环境（alpine 系，中国时区）：基础 `node:18-alpine3.19`，apk �?ustc 源，
预装开发工具链：vim / git / g++ / make / rsync / curl / autoconf / python3 / openssh-client�?

- Docker Hub tag：`sxc654/docker-node:18`（`.github/workflows/docker-image.yml` 自动构建推送）
- 基于 alpine 3.19 基础镜像（随上游 tag 绑定）；升级基础镜像时同步改 Dockerfile 行号�?ustc 源版本号

## 本地构建

```bash
cd node/18
docker build -t sxc654/docker-node:18 .
```

## 快速验�?

```bash
docker run --rm sxc654/docker-node:18 date    # 应为 CST（东八区�?
docker run --rm sxc654/docker-node:18 node -v # v18.x
docker run --rm sxc654/docker-node:18 git --version
```
