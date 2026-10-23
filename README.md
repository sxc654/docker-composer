# docker-composer

dockerhub 自动构建镜像仓库——多镜像家族统一维护：**一个子目录 = 一个镜像家族**，
家族内**一个版本子目录 = 一个可独立构建的镜像**。新增镜像家族（或给现有家族加新版本）
只需新建子目录（workflow 自动发现，零改动），不再开新仓库。

## 约定

```text
<家族名>/                 # 镜像家族（php / alpine / 后续新增…）
├── README.md             # 家族级总览（版本表、构建方式）
├── <版本1>/              # 一个版本 = 一个构建上下文（Dockerfile + README.md [+ vendor/patches 等依赖物]）
└── <版本2>/
```

- 构建上下文即版本子目录本身，`docker build -t <tag> <版本子目录>` 从不依赖仓库内其他路径
- Docker Hub tag：由约定推导为 `sxc654/docker-<家族名>:<版本名>`（php→`docker-php:7.4`，
  alpine→`docker-alpine:3.24`，node→`docker-node:18` / `:22` / `:nvm`），
  下游 `FROM` 不因仓库归拢而变动
- CI：`.github/workflows/docker-image.yml` **setup job 自动扫描**所有 `<家族>/<版本>/Dockerfile`
  生成构建矩阵，每版本一个并行 job（buildx + GHA 缓存）——**新增家族/版本 workflow 零改动**；
  Docker Hub Secrets 复用 `DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`
  （tag 规则即上述约定；不守约定或多 tag 特例时再考虑引入 manifest 逃生门）

## 当前成员

| 目录 | 内容 | Docker Hub tags |
|---|---|---|
| [`php/`](php/README.md) | PHP 基础镜像（alpine + fpm，中国时区，CVE 补丁） | `docker-php:7.4` `:8.5` |
| [`alpine/`](alpine/README.md) | GitLab CI 部署镜像（openssh-client + rsync + git + bash） | `docker-alpine:3.24` |
| [`node/`](node/README.md) | node 基础环境（版本：18 alpine / 22 slim；变体：nvm 多版本切换、aliyun-cli 部署工具） | `docker-node:18` `:22` `:nvm` `:aliyun-cli` |
| [`java/`](java/README.md) | Java 基础环境（openjdk17 完整 JDK 开发基座 / openjdk21 JRE 运行基座，alpine 3.22，中文字体 + UTF-8） | `docker-java:openjdk17` `:openjdk21` |

*（此表随成员增减维护，新家族加一行即可）*

## 快速上手（新增一个镜像家族）

1. 建子目录 `<家族名>/<版本>/Dockerfile`（可选 `README.md`、`vendor/` 等）
2. workflow **无需改动**——push 后 setup 自动发现该目录并按 matrix 构建
   （tag 自动推导为 `docker-<家族名>:<版本>`），仅需根 README 本表和对应家族 README 加一行
3. 构建期自检建议保留在 Dockerfile 里（缺扩展/缺工具/时区错即失败，参考现有家族写法）

## 本地构建

```bash
cd php/7.4 && docker build -t sxc654/docker-php:7.4 .
cd php/8.5 && docker build -t sxc654/docker-php:8.5 .
cd alpine/3.24 && docker build -t sxc654/docker-alpine:3.24 .
cd node/18 && docker build -t sxc654/docker-node:18 .
cd node/22 && docker build -t sxc654/docker-node:22 .
cd node/nvm && docker build -t sxc654/docker-node:nvm .
cd node/aliyun-cli && docker build -t sxc654/docker-node:aliyun-cli .
cd java/openjdk17 && docker build -t sxc654/docker-java:openjdk17 .
cd java/openjdk21 && docker build -t sxc654/docker-java:openjdk21 .
```

## 整理说明（历史）

- `php/`、`alpine/`、`node/` 分别由原仓库 `sxc654/docker-php`、`sxc654/docker-alpine`、
  `sxc654/docker-node` subtree 合并而来，完整提交历史保留在 merge commit 的 parent 链里；
  子目录名随后对齐约定（node 家族与 `php/7.4` 同款平铺：`node/node-18`→`node/18` 等，
  tag 推导无前缀剥离特例）；`sxc654/docker-npm` 同月并入——原 `npm/` 家族当日归拢为
  node 变体 `node/aliyun-cli/`，tag 随推断为 `docker-node:aliyun-cli`
- 2020 年的旧镜像（java/mongodb/wordpress/php7.1-7.2/gollum/timezone 等）已清理，如需回溯见旧清理提交之前的记录
- `java/` 2026-10 由原仓库 `sxc654/docker-java` subtree 合并而来（源 master=5e12c7c），
  目录 `openjdk-17`/`openjdk-21` 平铺为 `openjdk17`/`openjdk21`；tag 沿用 Hub 已发布的
  `docker-java:openjdk17`/`:openjdk21`（不改成 `17`/`21`，避免旧 tag 孤儿化、下游 FROM 断裂）；
  并入前同月已淘汰 Java 8 全家族（openjdk8 / openjdk8-font / openjre8 / maven）
