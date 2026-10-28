# python

Python 基础环境镜像家族：**一个版本子目录 = 一个可独立构建的镜像**，根 workflow 动态发现后按 `sxc654/docker-python:<版本目录名>` 构建推送。

## 约定

| 目录 | 基础镜像 | Docker Hub tag | 内容 |
|---|---|---|---|
| [`3.11/`](3.11/README.md) | `python:3.11-bullseye` | `sxc654/docker-python:3.11` | Python 3.11 **构建基座**：build-essential / pkg-config + mysqlclient / python-ldap / pyodbc 编译头 + curl/wget/git/unzip + archive.debian.org 冻结源 + pip 三件套预升级 + 构建期自检 |

*（此表随成员增减维护，加一行即可）*

- **只收"通用基座"**：具体应用的依赖（Oracle InstantClient、ODBC 驱动、应用源码）留在应用镜像里，
  不进本家族——否则基座会被单个项目绑架
- **Docker Hub tag**：`sxc654/docker-python:<版本目录名>`；新增 Python 小版本 = 建 `3.12/` 之类子目录，
  workflow 零改动
- **版本区间不是无限的**：下游应用决定可用版本。例如 Archery（Django 4.1）只支持 3.8–3.11，
  3.12+ 不可用；换版本必须在该应用里跑一遍验证清单

## 本地构建

```bash
cd python/3.11 && docker build -t sxc654/docker-python:3.11 .
```

## 构建后快速验证

```bash
docker run --rm sxc654/docker-python:3.11 sh -c \
  "python -V && gcc --version | head -1 && pkg-config --modversion mariadb && date"
# 期望：Python 3.11.x / gcc 10.x / mariadb 10.5.x / CST 时间
```
