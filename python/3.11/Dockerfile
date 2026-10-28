# sxc654/docker-python:3.11 —— Python 3.11 应用基座（Debian 11 bullseye）
#
# 定位：Python 应用镜像的**构建基座**（与 java/openjdk17 的"开发基座"同思路）：
#   - 与上游 python:3.11-bullseye 同源，解释器版本随 base tag 固定，不做多版本管理
#   - 常用编译链（build-essential / pkg-config）+ 三类 C 扩展头文件：
#     mysqlclient → libmariadb-dev，python-ldap → libldap2-dev + libsasl2-dev，pyodbc → unixodbc-dev
#   - 常用取包工具（curl / wget / git / unzip / tar / gnupg2）——下游构建脚本常直接依赖
#   - Debian 11 已 EOL（2026-08），deb.debian.org 的 bullseye-security 索引与 pool 已不一致
#     （实测 gnupg_2.2.27-2+deb11u3 全镜像 404）→ 源整体切 archive.debian.org 冻结包池
#   - 构建期自检：解释器版本、编译器、pkg-config 元数据、pip、venv，缺一项即失败
#
# 运行基座场景可在应用层收敛体积（示例：docker-archery 装完依赖后
# `apt-get purge -y build-essential && apt-get autoremove -y`）。
FROM python:3.11-bullseye

ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Debian 11 已 EOL：官方源 bullseye-security 的索引与 pool 已错位（实测 404），
# 源整体切 archive.debian.org 冻结包池；archive 的 Release 已过期，需关掉 Valid-Until 校验
RUN set -eux; \
    sed -i 's|deb http://deb.debian.org/debian|deb http://archive.debian.org/debian|g' /etc/apt/sources.list; \
    sed -i 's|deb http://security.debian.org|deb http://archive.debian.org/debian-security|g' /etc/apt/sources.list; \
    printf '%s\n' \
      'Acquire::Check-Valid-Until "false";' \
      'Acquire::Retries "5";' \
      > /etc/apt/apt.conf.d/99no-check-valid-until; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential pkg-config \
        libmariadb-dev libldap2-dev libsasl2-dev unixodbc-dev \
        curl wget git unzip tar ca-certificates gnupg2; \
    rm -rf /var/lib/apt/lists/*

# pip 三件套预升级：下游 `pip install` 不必每次重复解析旧 setuptools
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel

# 构建期自检：版本 / 编译器 / pkg-config 元数据 / pip / venv 缺一即构建失败
RUN set -eux; \
    python -V | grep -q '^Python 3\.11\.'; \
    gcc --version > /dev/null; g++ --version > /dev/null; make --version > /dev/null; \
    pkg-config --exists mariadb; \
    python -m pip --version > /dev/null; \
    python -m venv --help > /dev/null; \
    echo "python base check OK"

CMD ["python3"]
