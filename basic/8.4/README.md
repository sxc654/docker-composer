# docker-php php-8.4 基础镜像

alpine 下的 php 8.4 fpm 基础环境（中国时区）。

- 基础：`php:8.4-fpm-alpine3.24`（官方镜像，浮动 tag，跟随官方 8.4.x 更新）
- 扩展安装：**PIE**（`php pie.phar install`，PHP 官方继任安装器；pecl 频道 REST 已弃用）
  - `pie.phar`（PIE 1.5.3）vendor 在构建上下文 `basic/8.4/vendor/pie.phar`，
    Dockerfile 以 `RUN --mount=type=bind,source=vendor/pie.phar` 取用，仅构建期存在
- 第三方扩展（PIE，pin 版本）：`xdebug 3.5.3`、`mongodb 2.5.5`、`amqp 2.2.0`、`imagick 3.8.1`
- 官方扩展（`docker-php-ext-install`）：
  `soap` `pdo_mysql` `mysqli` `zip` `bcmath` `exif` `intl` `gd`(jpeg+freetype) `pcntl` `opcache`
  （`mysqli`/`exif`/`intl`/`bcmath` 为 WordPress 官方托管手册要求/常用）
- `mbstring` 由基础镜像自带，不重复编译（自检仍会断言它已加载）
- Composer：`curl https://getcomposer.org/installer | php` 安装，packagist 换 Aliyun 镜像
  （安装脚本未 pin 版本，后续可改 `COPY --from=composer:2` 或 pin + sha256）
- Xdebug 3.x（PIE 经 `docker-php-ext-enable` 写入的 `docker-php-ext-xdebug.ini`）：
  `xdebug.mode=debug`，`client_port=9005`，`start_with_request=no`
  （调试时在请求里带 `XDEBUG_SESSION_START` 触发）
- 时区：`/etc/localtime` + `conf.d/zz-timezone.ini`（`date.timezone=Asia/Shanghai`；
  PHP 不读 `/etc/localtime`，只设系统时区时 PHP 仍走 UTC）
- Alpine 源已换 `mirrors.ustc.edu.cn`；构建期含扩展完整性自检（`php -r` 断言 15 项扩展已加载 +
  xdebug ini 生效，缺任一项构建即失败）

## 标签

`sxc654/docker-php:8.4`（CI 自动构建推送）

## 与 php-7.4 的差异

| 项 | 7.4 | 8.4 |
|---|---|---|
| xdebug | 2.8.0（remote_* ini，端口 9000） | 3.5.3（mode/client_port ini，端口 9005） |
| 第三方扩展安装 | curl 直连 pecl tgz + `pecl install` | PIE（pecl REST 已弃用） |
| Composer | getcomposer.org 安装脚本 | 同 7.4（未 pin 版本） |
| CVE-2026-109618/109619 | 需打补丁重编译（已完成） | 官方版本不受影响，无需补丁 |

## 构建后快速验证

```bash
docker run --rm sxc654/docker-php:8.4 php -v          # PHP 8.4.x（随基础镜像浮动，当前 8.4.27）
docker run --rm sxc654/docker-php:8.4 php -m          # 应包含全部扩展
docker run --rm sxc654/docker-php:8.4 php --ri xdebug | grep -E "mode|client_port"
docker run --rm sxc654/docker-php:8.4 composer --version
```
