# docker-node-nvm

nvm 多版本切换镜像（glibc 系，中国时区）：基座 `debian:trixie-slim`（≈75MB，node 官方二进制
原生可跑），nvm v0.40.3（gitee 镜像拉取）做运行时版本管理，npmmirror 镜像下载 node 二进制，
预装 node 24 + 22 两个 LTS，默认 24。

- 基线内容：时区 Asia/Shanghai、npmmirror 注册表、全局 `pnpm@latest`、`git`
- 便捷链接：`/usr/local/bin/{node,npm,npx,corepack,pnpm}` → 构建期默认版本（24），
  容器内 `nvm use <版本>` 后 PATH 覆盖生效，便捷链接仅兜底非交互场景
- Docker Hub tag：`sxc654/docker-node:nvm`（`.github/workflows/docker-image.yml` 自动构建推送）
- **为什么不用 alpine 基座**：官方 node 二进制是 glibc 的，musl 下 gcompat 兼容层对
  node>=16 直接 reloc 崩溃（本地实测 `fcntl64: symbol not found`），nvm 又认不了
  unofficial-builds 的 `linux-x64-musl` 命名——debian slim 是小体积里的唯一可行解

## 本地构建

```bash
cd node-nvm
docker build -t sxc654/docker-node:nvm .
```

## 快速验证

```bash
docker run --rm sxc654/docker-node:nvm node -v     # v24.x（便捷链接 → 默认版本）
docker run --rm sxc654/docker-node:nvm bash -c '. nvm.sh && nvm use 22 >/dev/null && node -v'   # v22.x
docker run --rm sxc654/docker-node:nvm date        # 应为 CST（东八区）
docker run --rm sxc654/docker-node:nvm pnpm -v
docker run --rm sxc654/docker-node:nvm npm config get registry   # https://registry.npmmirror.com
```
