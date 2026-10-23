# docker-node:aliyun-cli

node 22 + 闃块噷浜?CLI 鐨勯儴缃?CI 闀滃儚锛坄sxc654/docker-node:aliyun-cli`锛夈€?

## 瀵规瘮鏃х増锛?.0.2 / node:10-alpine锛?

| 椤?| 鏃?| 鐜板湪 |
|---|---|---|
| 鍩哄骇 | `node:10-alpine`锛圗OL锛?| `sxc654/docker-node:22` |
| aliyun-cli | 3.0.2 | **3.5.2**锛坧in锛宻ha256 鏍￠獙锛?|
| 鏍￠獙 | 鏃?| 瀹樻柟 SHASUMS256 鍊煎唴宓屾柇瑷€ |
| 鍒嗗眰 | wget/tar/rm 鍚勫崰涓€灞?| 鍗?RUN 娓呯悊锛屾棤娈嬬暀灞?|
| 宸ュ叿 | git/openssh/rsync/make | git(鑷甫)/openssh-client/rsync锛屽幓鎺夋棤浜虹敤鐨?make |
| 鏃跺尯 | Asia/Shanghai | Asia/Shanghai锛堝熀搴ц嚜甯︼級 |
| 鑷 | 鏃?| 鏋勫缓鏈熸柇瑷€鐗堟湰/宸ュ叿/鏃跺尯 |

## 鏋勫缓

```sh
cd node/aliyun-cli
docker build --build-arg ALIYUN_CLI_VERSION=3.5.2 --build-arg ALIYUN_CLI_SHA256=8058cb91fa0e2d46a7c5fd47e44ab6a465be8477b28595d408dcc03a0ed5bd4e -t sxc654/docker-node:aliyun-cli .
```

鍗囩骇鐗堟湰锛氭敼涓婇潰涓や釜 ARG锛坰ha256 浠?[Release](https://github.com/aliyun/aliyun-cli/releases) 鐨?SHASUMS256.txt 鍙栵級銆?

## 鍐呭鐗?

- node 22锛坣pmmirror 宸查厤锛? npm锛堝熀搴э級
- git / openssh-client / rsync
- aliyun 3.5.2锛坄aliyun version` 楠岃瘉锛?

## 楠岃瘉鍛戒护

```sh
docker run --rm sxc654/docker-node:aliyun-cli sh -c "aliyun version && node -v && git --version && rsync --version | head -1 && date +%Z"
```
