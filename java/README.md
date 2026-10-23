# java

Java 基础环境镜像家族：**一个版本子目录 = 一个可独立构建的镜像**，根 workflow 动态发现后按 `sxc654/docker-java:<版本目录名>` 构建推送（alpine 3.22 基线，中国时区 + UTF-8）。

## 约定

| 目录 | 基础镜像 | Docker Hub tag | 内容 |
|---|---|---|---|
| [`openjdk17/`](openjdk17/README.md) | `alpine:3.22` | `sxc654/docker-java:openjdk17` | **完整 JDK17 开发基座**：openjdk17 + jdk + jmods + demos + doc + jre，字体（adobe-100dpi / ttf-dejavu / fontconfig），工具链（python3 + pip、git、make、curl、openssh-client、autoconf、supervisor），`TZ=Asia/Shanghai` + `JAVA_OPTS` 强制 UTF-8；≈483MB，可编译、可跑 maven |
| [`openjdk21/`](openjdk21/README.md) | `alpine:3.22` | `sxc654/docker-java:openjdk21` | **JRE21 运行基座**：openjdk21-jre-headless + 中文字体（fontconfig / ttf-dejavu / wqy-zenhei），`TZ=Asia/Shanghai` + `zh_CN.UTF-8` + `JAVA_OPTS` 强制 UTF-8；≈239MB，只跑 jar，无 javac |

*（此表随成员增减维护，加一行即可）*

- **Docker Hub tag**：`sxc654/docker-java:<版本目录名>`。目录名保留 `openjdk` 前缀是为了**沿用 Hub 已发布 tag**
  （`openjdk17` / `openjdk21`），下游 `FROM` 零改动；不改成纯 `17`/`21` 以免旧 tag 孤儿化
- **CI**：仓库根 `.github/workflows/docker-image.yml` 动态扫描发现，**新增版本 = 建子目录 + 本 README 表加行，workflow 零改动**；
  Secrets 复用仓库级 `DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`
- 两者差异：17 是开发基座（非 headless，随 JDK 包带入 libx11/alsa 等 GUI 库）、21 是部署运行基座
  （真 headless，但 `java.desktop` 模块仍在，中文字体可用于 PDF/图片渲染）

## 本地构建

```bash
cd java/openjdk17 && docker build -t sxc654/docker-java:openjdk17 .
cd java/openjdk21 && docker build -t sxc654/docker-java:openjdk21 .
```

## 构建后快速验证

```bash
docker run --rm sxc654/docker-java:openjdk17 sh -c "java -version && javac -version && date && fc-list | wc -l"
docker run --rm sxc654/docker-java:openjdk21 sh -c "java -version && date && fc-list | grep -ci wenquanyi"
# 两者 date 均为 CST；21 无 javac（JRE 运行基座），17 有完整 JDK
```

## 整理说明（历史）

- 家族由原仓库 `sxc654/docker-java` subtree 合并而来（2026-10，源 master=5e12c7c），完整提交历史保留在 merge commit 的 parent 链里
- 目录 `openjdk-17/`、`openjdk-21/` 平铺为 `openjdk17/`、`openjdk21/`，tag 仍是 `docker-java:openjdk17` / `:openjdk21`
- 2026-10 淘汰 Java 8 全家：`openjdk-8`（tag `openjdk8`）、`openjdk-8-font`（`openjdk8-font`）、
  `openjre-8`（`openjre8`）、`maven-3.6.3`（`maven`，基座 `:openjdk8`）；Hub 上 4 个旧 tag 由用户手动删除
- `openjdk17` 同月基座由 `alpine:3.17`（已 EOL）升到 `alpine:3.22`，换源（nju）/ENV 写法与 openjdk21 对齐，实测 java 17.0.19 + javac 17.0.19
