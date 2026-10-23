# sxc654/docker-node:aliyun-cli — node 22 部署镜像（git/ssh/rsync + 阿里云 CLI）
# 基座：sxc654/docker-node:22（node 22 + git/curl + CA + tzdata + Asia/Shanghai + deb 源已指 ustc）
FROM sxc654/docker-node:22

# aliyun-cli 官方 Linux AMD64 包（阿里 CDN，与 GitHub Release 同源同校验）
# SHA256 取自官方 release 附带的 SHASUMS256.txt
ARG ALIYUN_CLI_VERSION=3.5.2
ARG ALIYUN_CLI_SHA256=8058cb91fa0e2d46a7c5fd47e44ab6a465be8477b28595d408dcc03a0ed5bd4e

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-client rsync \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/aliyun-cli.tgz "https://aliyuncli.alicdn.com/aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz" \
    && echo "${ALIYUN_CLI_SHA256}  /tmp/aliyun-cli.tgz" | sha256sum -c - \
    && tar -xzf /tmp/aliyun-cli.tgz -C /tmp \
    && mv /tmp/aliyun /usr/local/bin/ \
    && rm -rf /tmp/aliyun-cli.tgz

# 构建期完整性自检：版本、工具链、时区任一不满足直接构建失败
RUN aliyun version | grep -q "${ALIYUN_CLI_VERSION}" \
    && command -v aliyun node npm git ssh rsync scp >/dev/null \
    && node -v | grep -q "^v22\." \
    && [ "$(date +%Z)" = "CST" ] \
    && echo "aliyun-cli check OK"
