# docker-php

alpine下的php7.4基本环境 (中国时区)

## CVE-2026-109618 / CVE-2026-109619 (php2shell) 安全修复说明

2026-10-21 PHP 安全公告：两个 CVSS 9.2 未认证 RCE，影响所有 PHP < 8.2 的运行时本身。
PHP 7.4 已 EOL，官方安全团队为 7.4 分支发布了最小源码 backport。

本镜像构建方式：

1. 基础镜像 `php:7.4-fpm-alpine3.16` —— 官方 PHP 7.4 最终构建（7.4.33）。
   旧版基于 `php:7.4-fpm-alpine3.12`，停在 PHP 7.4.20，官方已不再更新。
2. `COPY` 并应用官方补丁（vendored: `patches/php-7.4-CVE-2026-109618-109619.patch`，
   sha256 `d059c1b4ea0f9023a1e1c17f6eddee82e3c2e029c60dd0a08fc5466764b5eaa4`，来源
   https://github.com/php/php-src/commit/712e60f9edfd03f0960fc4fc3c2c375f42b90aa2 ）
   补丁内容：去掉 OOM 时 longjmp 带来的状态破坏、请求关闭时清空残留全局状态、
   代码级禁用 session upload-progress。
3. 按官方同款 configure 参数原位重编译 PHP，扩展与工具链保持不变。
4. `conf.d/zz-security-php2shell.ini` 设 `session.upload_progress.enabled = 0`
   作为纵深防御（补丁已代码级禁用，此为兜底）。
5. `conf.d/zz-timezone.ini` 设 `date.timezone = Asia/Shanghai`（PHP 不读
   `/etc/localtime`，必须显式设 ini 才能得到正确的 PHP 侧时区；与 8.4 对齐）。
6. 扩展安装与 8.4 同一套扩展集（xdebug 2.8.0 / mongodb 1.16.1 / amqp / imagick 3.8.1
   经 pecl 安装），构建尾声 `php -r` 自检：16 项扩展已加载 + xdebug remote ini
   生效 + PHP 时区为 Asia/Shanghai，缺任一项构建直接失败。

## 构建

```bash
cd basic/7.4
docker build -t sxc654/docker-php:7.4-cve-fix .
```

## 构建后验证（必须全部通过）

```bash
docker run --rm sxc654/docker-php:7.4-cve-fix php -v          # PHP 7.4.33（fpm 同理）
docker run --rm sxc654/docker-php:7.4-cve-fix php -m          # 模块列表完整
docker run --rm sxc654/docker-php:7.4-cve-fix php -i | grep upload_progress
# session.upload_progress.enabled => 0 => 0
docker run --rm sxc654/docker-php:7.4-cve-fix sh -c 'ls /usr/src; php -r '\''$s = phpversion(); echo $s, "\n"; phpinfo();'\'' | grep -A2 "Configure Command"'
```

注意：补丁修复的是运行时 C 层漏洞，`php -v` 无法反映——版本应为 7.4.33 且镜像
由打了补丁的源码重编译而成（构建日志中 `patch` 步骤成功即为证据）。

## 下游切换

所有 `FROM sxc654/docker-php:7.4` 的业务镜像改用新 tag（如
`sxc654/docker-php:7.4-cve-fix`）重建部署即可；建议立即下调业务镜像里
`post_max_size = 1000M/100M` 的超大配置（CVE-2026-109618 的触发面是超大
multipart 请求）。
