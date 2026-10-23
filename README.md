# docker-composer

dockerhub 自动构建镜像仓库——docker-php 与 docker-alpine 两个镜像家族在此统一维护，新增版本/成员只需在对应目录下加子目录，无需再开新仓库。

## 目录

| 子目录 | 内容 | Docker Hub tags |
|---|---|---|
| [`php/`](php/README.md) | PHP 基础镜像（alpine + fpm，中国时区，CVE 补丁），详见 [php/README.md](php/README.md) | `sxc654/docker-php:7.4` `:8.5` |
| [`alpine/`](alpine/README.md) | GitLab CI 部署镜像（openssh-client + rsync + git + bash），详见 [alpine/README.md](alpine/README.md) | `sxc654/docker-alpine:3.24` |

## CI 构建

推送到 `master` 后 GitHub Actions 自动构建三个镜像并推送 Docker Hub（`.github/workflows/docker-image.yml`，三 job 并行，GHA 缓存）。Docker Hub Secrets：`DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`。

## 本地构建

```bash
cd php/7.4 && docker build -t sxc654/docker-php:7.4 .
cd php/8.5 && docker build -t sxc654/docker-php:8.5 .
cd alpine/3.24 && docker build -t sxc654/docker-alpine:3.24 .
```

## 整理说明（历史）

- `php/` 与 `alpine/` 分别由原仓库 `sxc654/docker-php`、`sxc654/docker-alpine` subtree 合并而来，完整提交历史保留在两个 merge commit 的 parent 链里
- 2020 年的旧镜像（java/mongodb/wordpress/php7.1-7.2/gollum/timezone 等）已清理，如需回溯见 `<第一次清理提交>` 之前的提交
