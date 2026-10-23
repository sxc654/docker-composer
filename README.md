# docker-php

docker 下 PHP 基础镜像（alpine + fpm，中国时区 `Asia/Shanghai`，预装常用扩展），CI 自动构建并推送 Docker Hub。

## 版本

| tag | 基础镜像 | PHP 版本 | 扩展安装方式 | 说明 |
|---|---|---|---|---|
| `sxc654/docker-php:7.4` | `php:7.4-fpm-alpine3.16` | 7.4.33（7.4 分支最终版） | pecl | EOL 分支，应用官方 CVE-2026-109618/109619 补丁原位重编译（xdebug 2.8.0 / mongodb 1.16.1 / amqp / imagick 3.8.1） |
| `sxc654/docker-php:8.5` | `php:8.5-fpm-alpine3.24` | 8.5.x 常驻跟随（现值 8.5.12） | PIE 1.5.3 官方安装器 | 现行版本（xdebug 3.5.3 / mongodb 2.5.5 / amqp 2.2.0 / imagick 3.8.1） |

## 目录结构

```text
basic/
├── 7.4/            # Dockerfile、README、CVE 补丁（patches/）、pie.phar 同款 vendor
└── 8.5/            # Dockerfile、README、vendor/pie.phar（仅构建期挂载使用）
```

## 本地构建

```bash
cd basic/7.4 && docker build -t sxc654/docker-php:7.4 .
cd basic/8.5 && docker build -t sxc654/docker-php:8.5 .
```

## CI 构建

推送到 `master` 后 GitHub Actions 自动构建测试两个版本并推送 Docker Hub（见 `.github/workflows/docker-image.yml`）。

## 构建后快速验证

```bash
docker run --rm sxc654/docker-php:7.4 php -v       # PHP 7.4.33（含安全补丁，ext 列表完整）
docker run --rm sxc654/docker-php:8.5 php -v       # PHP 8.5.x + Xdebug 3.5.3 + Zend OPcache
docker run --rm sxc654/docker-php:7.4 php -i | grep date.timezone
docker run --rm sxc654/docker-php:8.5 php -i | grep date.timezone
# 两者均为 Asia/Shanghai（PHP 侧 date.timezone 由 conf.d/zz-timezone.ini 显式设置）
```
