# wxwork —— 企业微信会话存档扩展（应用特设，非基础环境家族）

`wxwork_finance_sdk` = 企业微信会话存档 PHP 扩展 + 各代 C SDK 二进制。本目录是它在
docker-composer 仓库中的存放与本地构建位，**独立于 php 等家族的 CI 构建**——
不推 Docker Hub，需要时本地构建部署即可（会话存档为企业微信特设能力，只对
需要此能力的运行环境叠加）。

## 目录

```text
wxwork/
├── Dockerfile             # 构建文件 → 产物 sxc654/docker-php:7.4-wxwork-finance-sdk
│                          #   （基座 sxc654/docker-php:7.4 + wxwork_finance_sdk.so 对接 SDK v2.0）
├── README.md              # 本文件
└── wxwork_finance_sdk/    # pangdahua/php7-wxwork-finance-sdk 整体拷贝，内容保持上游原样
                           #   （根 = PHP 扩展源码；v1.0/v1.1/v1.2/v2.0 = 各代 C SDK）
```

上游详细文档（扩展用法、SDK 说明）：见 [wxwork_finance_sdk/README.md](./wxwork_finance_sdk/README.md)。

## 为什么 CI 不会碰它

CI（`.github/workflows/docker-image.yml`）对家族/版本的发现规则是
`find . -mindepth 3 -maxdepth 3 -name Dockerfile`：

- 本 `wxwork/Dockerfile` 位于第 2 层，扫描不到；
- `wxwork/wxwork_finance_sdk/` 下没有 Dockerfile，也不落在任何 `<家族>/<版本>/` 前缀内。

所以本目录的提交（含文档/SDK 更新）对 CI 全程无感，永远不会构建或推送。

## 本地构建（仓库根执行）

```bash
docker build -t sxc654/docker-php:7.4-wxwork-finance-sdk wxwork
```

> 前提：基座 `sxc654/docker-php:7.4` 为 2026-10-24 之后的版本（apk 源已切 aliyun，
> 见 `php/7.4/Dockerfile`）。CI 重建推送基座后 `docker pull` 即可用。

## 构建后快速验证

```bash
docker run --rm sxc654/docker-php:7.4-wxwork-finance-sdk php -m | grep wxwork_finance_sdk
docker run --rm sxc654/docker-php:7.4-wxwork-finance-sdk php -r 'var_dump(class_exists("WxworkFinanceSdk"));'
```

（构建镜像最后一个 RUN 已含同款自检：扩展加载失败即构建失败，不会带病成镜像。）

## 换基座 / 换 SDK 版本

改 `wxwork/Dockerfile` 中两处即可：

1. `FROM sxc654/docker-php:<新基座>`
2. `--with-wxwork-finance-sdk=<SDK 版本目录>`（`v1.0`/`v1.1`/`v1.2`/`v2.0`，目录需同时含
   `WeWorkFinanceSdk_C.h` 与 `libWeWorkFinanceSdk_C.so`）

产物 tag 相应调整。注意 `wxwork/wxwork_finance_sdk/` 内文件不要增删改（保持与上游拷贝一致）。
