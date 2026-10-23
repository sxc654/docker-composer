# docker-php php-8.5 基础镜像

alpine 下的 php 8.5 fpm 基础环境（中国时区）。扩展集与 php/7.4 同一套，镜像架构
（.build-deps 工具链卸载、pie.phar 挂载、时区 ini、构建期自检）同一套，扩展安装体系
按 8.5 现状调整：PIE 替代 pecl，opcache 由 8.5 内建。

- 基础：`php:8.5-fpm-alpine3.24`（官方镜像，浮动 tag，跟随官方 8.5.x 更新；现值 8.5.12）
- 扩展安装：**PIE**（`php pie.phar install`，PHP 官方继任安装器；pecl 频道 REST 已弃用）
  - `pie.phar`（PIE 1.5.3）vendor 在构建上下文 `php/8.5/vendor/pie.phar`，
    Dockerfile 以 `RUN --mount=type=bind,source=vendor/pie.phar` 取用，仅构建期存在
- 第三方扩展（PIE，pin 版本，均兼容 8.5）：`xdebug 3.5.3`（php >=8.0,<8.6）、
  `mongodb 2.5.5`（>=8.1,<9）、`amqp 2.2.0`（>=7.4）、`imagick 3.8.1`（>=5.6）
- 官方扩展（`docker-php-ext-install`）：
  `soap` `pdo_mysql` `mysqli` `zip` `bcmath` `exif` `intl` `gd`(jpeg+freetype) `pcntl`
  （`mysqli`/`exif`/`intl`/`bcmath` 为 WordPress 官方托管手册要求/常用）
- `mbstring` 与 `opcache` 由 PHP 8.5 内建（opcache 默认启用）——8.5 不能再显式
  `docker-php-ext-install opcache`（已 static build 的扩展再 install，
  `make install` 会报 `cp: can't stat 'modules/*'` 直接失败；自检仍会断言已加载）
- Composer：`curl https://getcomposer.org/installer | php` 安装，packagist 换 Aliyun 镜像
- Xdebug 3.x（PIE 经 `docker-php-ext-enable` 写入的 `docker-php-ext-xdebug.ini`）：
  `xdebug.mode=debug`，`client_port=9005`，`start_with_request=no`
  （调试时在请求里带 `XDEBUG_SESSION_START` 触发）
- 时区：`/etc/localtime` + `conf.d/zz-timezone.ini`（`date.timezone=Asia/Shanghai`；
  PHP 不读 `/etc/localtime`，只设系统时区时 PHP 仍走 UTC）
- 瘦身：编译工具链与 `-dev` 库进 `--virtual .build-deps` 编译后卸载；`libgomp`
  （imagick.so 的 OpenMP 运行期依赖）显式保留
- Alpine 源已换 `mirrors.ustc.edu.cn`；构建期自检（`php -r` 断言 15 项扩展已加载 +
  xdebug ini 生效 + 时区，缺任一项构建即失败）

## 标签

`sxc654/docker-php:8.5`（CI 自动构建推送）

## 与 php-7.4 的差异

| 项 | 7.4 | 8.5 |
|---|---|---|
| PHP 版本 | 7.4.33（7.4 分支最终版） | 8.5.x（浮动 tag，现值 8.5.12） |
| 扩展安装器 | pecl | PIE 1.5.3（packagist 锁版本） |
| 第三方扩展 pin | xdebug 2.8.0 / mongodb 1.16.1 / amqp / imagick 3.8.1 | xdebug 3.5.3 / mongodb 2.5.5 / amqp 2.2.0 / imagick 3.8.1 |
| CVE-2026-109618/109619 | 需官方补丁原位重编译（vendored patch） | 官方版本不受影响 |

## 构建后快速验证

```bash
docker run --rm sxc654/docker-php:8.5 php -v          # PHP 8.5.x（随基础镜像浮动，当前 8.5.12）
docker run --rm sxc654/docker-php:8.5 php -m          # 应包含全部扩展
docker run --rm sxc654/docker-php:8.5 php --ri xdebug | grep -E "mode|client_port"
docker run --rm sxc654/docker-php:8.5 composer --version
```
