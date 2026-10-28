# docker-python:3.11

Python 3.11 应用**构建基座**：`python:3.11-bullseye` + 常用编译链 + C 扩展头文件 + 冻结的 Debian 源。

## 内容

| 类别 | 包 | 用途 |
|---|---|---|
| 编译链 | `build-essential`、`pkg-config` | 源码编译 wheel（mysqlclient / python-ldap / pyodbc / cassandra-driver 等） |
| MySQL | `libmariadb-dev` | `mysqlclient`（`mariadb_config` 由 pkg-config 提供） |
| LDAP | `libldap2-dev`、`libsasl2-dev` | `python-ldap`（django-auth-ldap 依赖） |
| ODBC | `unixodbc-dev` | `pyodbc` |
| 工具 | `curl`、`wget`、`git`、`unzip`、`tar`、`ca-certificates`、`gnupg2` | 下游构建脚本常直接依赖 |
| Python | `pip` / `setuptools` / `wheel` 预升级 | 避免下游每次构建重复解析旧 setuptools |

`ENV`：`TZ=Asia/Shanghai`、`LANG=C.UTF-8`、`PYTHONUNBUFFERED=1`、`PYTHONDONTWRITEBYTECODE=1`、`PIP_DISABLE_PIP_VERSION_CHECK=1`。

## Debian 源：为什么是 archive.debian.org

Debian 11（bullseye）已过 LTS 窗口（2026-08）。实测官方源与国内镜像都出现
**`bullseye-security` 索引与 pool 错位**：索引里列的 `gnupg_2.2.27-2+deb11u3` 等包在
deb.debian.org / ustc / tuna / aliyun 全部 404，`apt-get install` 必然失败。

处理方式（见 Dockerfile）：

```sh
sed -i 's|deb http://deb.debian.org/debian|deb http://archive.debian.org/debian|g' /etc/apt/sources.list
sed -i 's|deb http://security.debian.org|deb http://archive.debian.org/debian-security|g' /etc/apt/sources.list
echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until
```

archive 的包池是冻结的（可复现），但**不再有安全更新**——这是"与下游应用同一代系统库
（Archery 的 `setup.sh` 写死 `packages.microsoft.com/config/debian/11`、`libaio1`）"换来的代价。
升级 bookworm 时，本文件与下游应用的 msodbc/percona 源路径要同步改。

## 构建

```bash
docker build -t sxc654/docker-python:3.11 .
docker build --check .      # 零警告
```

## 构建期自检

Dockerfile 末尾断言：解释器为 `Python 3.11.*`、`gcc`/`g++`/`make` 可用、
`pkg-config --exists mariadb`、pip 与 venv 可用——缺一项即构建失败。

## 体积

≈ 1.46 GB（未压缩，含 build-essential 与 Python 全量镜像）；压缩 ≈384 MB（Hub 实测）。
应用层可在装完依赖后 `apt-get purge -y build-essential && apt-get autoremove -y` 收敛
（`docker-archery` 就是这么做的）。

## 注意

- base tag 用浮动 `python:3.11-bullseye`（3.11 系列补丁版本自动跟随），要完全可复现时
  改成 `python:3.11.x-bullseye` 并同步本 README
- 本基座**不含**应用依赖（Oracle 客户端、msodbc、应用源码），按家族约定留在应用镜像
- 3.12+ 不要直接建目录：下游 Django 4.1 不支持
