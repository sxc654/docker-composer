# docker-java:openjdk21

JDK21 运行时基础镜像（`alpine:3.22`）：`openjdk21-jre-headless` + 中文字体（fontconfig、ttf-dejavu、wqy-zenhei），默认 `TZ=Asia/Shanghai`、`LANG` / `LC_ALL=zh_CN.UTF-8`，`JAVA_OPTS` 强制 `-Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8`。

> 只含 JRE（无 javac 等编译工具），作为部署运行基座；需要编译请用 `openjdk-17`。
> Alpine 是 musl，无 glibc locale 数据，实际编码由 `JAVA_OPTS` 保证。

apk 源：`mirrors.nju.edu.cn`（由 `dl-cdn.alpinelinux.org` 全局替换）。

## 构建

```bash
docker build -t sxc654/docker-java:openjdk21 openjdk-21
```

## 用法

```bash
docker run --rm sxc654/docker-java:openjdk21 java -version
```
