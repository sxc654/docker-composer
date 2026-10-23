# docker-alpine 3.24

alpine 极简 CI 部署镜像（中国时区）：openssh-client + rsync + git + bash，用于 pipeline 里的
ssh-agent 解锁私钥 → rsync 同步产物 → 重启远端服务这类部署 job。

- 基础：`alpine:3.24`（官方镜像，浮动 tag 跟随官方 3.24.x 更新；现值 3.24.3）
- 安装内容（全部运行期保留，无编译 dependency）：
  `openssh-client`（`ssh` / `ssh-agent` / `ssh-add`）、`rsync`、`git`、`bash`、
  `ca-certificates`（HTTPS 源）、`tzdata`（仅构建期拷出 Asia/Shanghai 后卸载）
- git：GitLab CI runner 环境虽会 sync 代码仓，部署 job 内触发 git push/clone 子仓等
  场景仍需本地 git，直接装上；alpine busybox
  自含标准工具集（sh/cp/mv/find/xargs 等均可直接用）
- 时区：`/etc/localtime` + `/etc/timezone`（tzdata 拷出即 `/etc/localtime` 后 apk del），
  系统时间即东八区，无需额外配置
- Alpine 源已换 `mirrors.ustc.edu.cn`；构建期自检（CST + ssh/rsync/git/tar 可用，
  缺任一项构建即失败）
- 构建上下文只有 Dockerfile 一个文件

## 标签

`sxc654/docker-alpine:3.24`（`.github/workflows/build-and-push.yml` 自动构建推送）；
仓库需在 GitHub 上配置 Secrets：`DOCKERHUB_USERNAME` + `DOCKERHUB_TOKEN`。
出新版本（如 3.25）时：新建 `3.25/` 子目录 + workflow 里增加对应 job（如缓存容量吃紧，
可考虑移除 `cache-to` 或按 job 拆分）

## 构建

```bash
cd 3.24
docker build -t sxc654/docker-alpine:3.24 .
```

## GitLab CI 用法示例

```yaml
deploy-to-prod:
  stage: deploy
  image: sxc654/docker-alpine:3.24
  before_script:
    - eval $(ssh-agent -s)
    - echo "$DEPLOY_SSH_PRIVATE_KEY" | ssh-add -
  script:
    - rsync -avz --delete ./dist/ deploy@prod.example.com:/srv/app/
    - ssh deploy@prod.example.com 'systemctl restart myapp'
```

变量 `DEPLOY_SSH_PRIVATE_KEY` 放 GitLab CI/CD Variables（Protect + Mask by file）里。

## 构建后快速验证

```bash
docker run --rm sxc654/docker-alpine:3.24 ssh -V
docker run --rm sxc654/docker-alpine:3.24 rsync --version | head -1
docker run --rm sxc654/docker-alpine:3.24 git --version
docker run --rm sxc654/docker-alpine:3.24 date          # 应为 CST（东八区，无 utc 偏移错误）
docker run --rm sxc654/docker-alpine:3.24 cat /etc/timezone
```
