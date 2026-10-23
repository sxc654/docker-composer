# docker-java:openjdk17

完整 JDK17 基础镜像（`alpine:3.17`）：openjdk17 / jdk / jmods / demos / doc / jre，附字体（adobe-100dpi、ttf-dejavu、fontconfig）与构建工具链（python3 + pip、git、make、curl、openssh-client、supervisor），时区 `Asia/Shanghai`。可编译、可跑 maven。

apk 源：`mirrors.nju.edu.cn`。

## 构建

```bash
docker build -t sxc654/docker-java:openjdk17 openjdk-17
```

## 用法

```bash
docker run --rm sxc654/docker-java:openjdk17 java -version
```
