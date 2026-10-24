# sxc654/docker-php:7.4-wxwork-finance-sdk —— 企业微信会话存档扩展镜像
#
# ⚠ 不进 CI、不推 Docker Hub（约定，2026-10-24；会话存档是应用特设能力，非基础环境家族）：
#   ① 本文件位于仓库根第 2 层（wxwork/Dockerfile），CI 发现规则
#      `find . -mindepth 3 -maxdepth 3 -name Dockerfile` 从第 3 层起扫，扫不到它 →
#      workflow 零改动，永不构建推送；
#   ② wxwork/wxwork_finance_sdk/（SDK 整体拷贝）也不是任何 <家族>/<版本>/ 上下文，
#      当中文件的 diff 永远落不进构建矩阵——它的提交对 CI 视同纯文档提交。
#
# 构建方式（本地，仓库根执行）：
#   docker build -t sxc654/docker-php:7.4-wxwork-finance-sdk wxwork
#   前提：基座 sxc654/docker-php:7.4 已为 aliyun 源版（2026-10-24 起随 CI 重建发布后拉取）。
#
# 物料来源：pangdahua/php7-wxwork-finance-sdk 整体拷贝（PHP 扩展源码在
# wxwork_finance_sdk/ 根，C SDK v1.0/v1.1/v1.2/v2.0 = 各代头文件 + libWeWorkFinanceSdk_C.so），
# 其内文件保持上游原样。上游文档见 ./wxwork_finance_sdk/README.md。
#
# 镜像源随基座：php/7.4 基座已切 aliyun http 源（本机 BuildKit 下 ustc 不稳定），本文件不做源替换。
# alpine(musl) 适配：musl 运行期不搜 /usr/local/lib，php-fpm 又会清空进程 ENV；
# 官方参考片段基于 glibc 镜像，这里须把 libWeWorkFinanceSdk_C.so 符号链接进
# /usr/lib 才能随扩展加载（构建期自检会兜底验证）。
#
# 换基座 / 换 SDK 版本：改下方 FROM 与 --with-wxwork-finance-sdk=<版本目录> 即可；
# 产物 tag 相应调整（仅本地使用）。
FROM sxc654/docker-php:7.4

COPY wxwork_finance_sdk /usr/local/lib/php/wxwork_finance_sdk

RUN set -eux; \
    apk add --no-cache --virtual .wxwork-build-deps $PHPIZE_DEPS; \
    cd /usr/local/lib/php/wxwork_finance_sdk; \
    phpize; \
    ./configure --with-php-config=/usr/local/bin/php-config --with-wxwork-finance-sdk=v2.0; \
    make -j "$(nproc)"; \
    make install; \
    echo "extension=wxwork_finance_sdk.so" > /usr/local/etc/php/conf.d/wxwork_finance_sdk.ini; \
    ln -s /usr/local/lib/php/wxwork_finance_sdk/v2.0/libWeWorkFinanceSdk_C.so \
          /usr/lib/libWeWorkFinanceSdk_C.so; \
    apk del .wxwork-build-deps

# 构建期自检：扩展要能加载（SO 依赖一并解析），缺件在此直接失败，不等运行时
RUN php -m | grep -qx wxwork_finance_sdk
