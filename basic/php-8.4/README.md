# docker-php php-8.4 基础镜像

alpine 下的 php 8.4 fpm 基础环境（中国时区）。

- 基础：`php:8.4.27-fpm-alpine3.24`（官方镜像）
- 扩展：`xdebug`、`mongodb`、`amqp`（pecl）+ `soap` `pdo_mysql` `mbstring` `zip` `gd` `pcntl` `opcache`（内建）
- Composer + 阿里云 packagist 镜像
- Xdebug 3.x：`xdebug.mode=debug`，`client_port=9005`，`start_with_request=no`（调试时在请求里带 `XDEBUG_SESSION_START` 触发）
- 阿尔卑斯源已换 `mirrors.ustc.edu.cn`

## 标签

`sxc654/docker-php:8.4`（CI 自动构建推送）

## 与 php-7.4 的差异

| 项 | 7.4 | 8.4 |
|---|---|---|
| xdebug | 2.8.0（remote_* ini） | 3.5.3（mode/client_port ini） |
| xdebug 端口 | 9000 | 9005 |
| PHP CVE-2026-109618/109619 | 需打补丁重编译（已完成） | 官方版本本身不受影响，无需补丁 |
| pecl 安装方式 | curl 直连 tgz + 本地安装（PECL REST 已弃用） | 同 7.4 |

## 构建后快速验证

```bash
docker run --rm sxc654/docker-php:8.4 php -v          # PHP 8.4.27
docker run --rm sxc654/docker-php:8.4 php -m          # 应包含 xdebug.mongodb.amqp.soap.gd.pcntl.opcache
docker run --rm sxc654/docker-php:8.4 php --ri xdebug | grep -E "mode|client_port"
docker run --rm sxc654/docker-php:8.4 composer --version
```
