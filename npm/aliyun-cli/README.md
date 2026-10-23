# docker-npm:aliyun-cli

node 22 + 阿里云 CLI 的部署/CI 镜像（`sxc654/docker-npm:aliyun-cli`）。

## 对比旧版（3.0.2 / node:10-alpine）

| 项 | 旧 | 现在 |
|---|---|---|
| 基座 | `node:10-alpine`（EOL） | `sxc654/docker-node:22` |
| aliyun-cli | 3.0.2 | **3.5.2**（pin，sha256 校验） |
| 校验 | 无 | 官方 SHASUMS256 值内嵌断言 |
| 分层 | wget/tar/rm 各占一层 | 单 RUN 清理，无残留层 |
| 工具 | git/openssh/rsync/make | git(自带)/openssh-client/rsync，去掉无人用的 make |
| 时区 | Asia/Shanghai | Asia/Shanghai（基座自带） |
| 自检 | 无 | 构建期断言版本/工具/时区 |

## 构建

```sh
cd aliyun-cli
docker build --build-arg ALIYUN_CLI_VERSION=3.5.2 --build-arg ALIYUN_CLI_SHA256=8058cb91fa0e2d46a7c5fd47e44ab6a465be8477b28595d408dcc03a0ed5bd4e -t sxc654/docker-npm:aliyun-cli .
```

升级版本：改上面两个 ARG（sha256 从 [Release](https://github.com/aliyun/aliyun-cli/releases) 的 SHASUMS256.txt 取）。

## 内容物

- node 22（npmmirror 已配）/ npm（基座）
- git / openssh-client / rsync
- aliyun 3.5.2（`aliyun version` 验证）

## 验证命令

```sh
docker run --rm sxc654/docker-npm:aliyun-cli sh -c "aliyun version && node -v && git --version && rsync --version | head -1 && date +%Z"
```
