# docker-alpine

GitLab CI 部署镜像（alpine，中国时区）：openssh-client（`ssh` / `ssh-agent` / `ssh-add`）
+ `rsync` + `git` + `bash`，用于 pipeline 里的 ssh-agent 解锁私钥 → rsync 同步产物 →
重启远端服务这类部署 job。

## 版本

| 子目录 | 基础镜像 | Docker Hub tag | 说明 |
|---|---|---|---|
| [`3.24/`](3.24/README.md) | `alpine:3.24`（现值 3.24.3） | `sxc654/docker-alpine:3.24` | 当前版本，详见 [3.24/README.md](3.24/README.md) |

出新版本（如 3.25）时新建同级子目录，文档同理。

## 本地构建

```bash
cd 3.24
docker build -t sxc654/docker-alpine:3.24 .
```

## 快速验证

```bash
docker run --rm sxc654/docker-alpine:3.24 ssh -V     # OpenSSH 客户端（含 ssh-agent / ssh-add）
docker run --rm sxc654/docker-alpine:3.24 git --version
docker run --rm sxc654/docker-alpine:3.24 date       # CST（东八区）
```
