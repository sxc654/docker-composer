# docker-java

Java 基础环境镜像：**一个版本子目录 = 一个镜像**，tag 推导为 `sxc654/docker-java:<目录名>`。

| 目录 | 基础镜像 | Docker Hub tag | 内容 |
|---|---|---|---|
| `openjdk-17/` | `alpine:3.17` | `sxc654/docker-java:openjdk17` | 完整 JDK17 + 字体（adobe-100dpi / ttf-dejavu / fontconfig）+ python3 / pip + git / make / curl / ssh 等构建工具 |
| `openjdk-21/` | `alpine:3.22` | `sxc654/docker-java:openjdk21` | JDK21 **JRE 运行时**（openjdk21-jre-headless）+ 中文字体（wqy-zenhei）+ `TZ=Asia/Shanghai` / `zh_CN.UTF-8` |

详细用法见各目录 README。

## 构建与推送

```bash
# 目录名即 tag
docker build -t sxc654/docker-java:openjdk21 openjdk-21
docker push sxc654/docker-java:openjdk21
```

## 已淘汰（2026-10 清理）

Java 8 系列全部除名（镜像陈旧、仓库内无任何引用）：

| 原目录 | 原 Docker Hub tag | 说明 |
|---|---|---|
| `openjdk-8/` | `openjdk8` | alpine:edge + openjdk8 |
| `openjdk-8-font/` | `openjdk8-font` | 基于 `openjdk8` 加字体 |
| `openjre-8/` | `openjre8` | alpine:edge + openjdk8-jre-base |
| `maven-3.6.3/` | `maven` | 基于 `openjdk8` 加 maven 3.6.3，随 Java 8 一并除名；需要 maven 时请基于 `openjdk-17` / `openjdk-21` 新建 |
