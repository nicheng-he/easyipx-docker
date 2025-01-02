# 内网穿透 easyipx部署

## 官方部署方式
请参考 [easyipx 官方文档](https://github.com/your-repo/easyipx/blob/main/README.md) 获取更多信息。

## Docker镜像启动方式

### 使用现有镜像
其中 /path/ssl/ 为证书存放路径 version 为使用的版本号
```bash
docker run -d \
  --name easyipx \
  --restart always \
  --network host \
  -v /path/ssl/:/opt/easyipx/ssl/ \
  registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:${version}
```

镜像版本| 镜像地址                                                               |镜像描述
-----------|--------------------------------------------------------------------|--
amd64-4.0.3| registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:amd64-4.0.3 |linux/amd64架构
amd64-3.2.0| registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:amd64-3.2.0 |linux/amd64架构

### 自行构建
1. **拉取源码**
```bash
git clone git@github.com:nicheng-he/easyipx-docker.git
```
2. **从 [easyipx 官方仓库](https://github.com/imxiny/easyipx/) 下载对应版本的 `easyipx` 二进制文件**
 - 并放置第一步目录内
3. **构建镜像**
 - 设置`VERSION`为你需要的版本,例如4.0.3
 - 设置`ARCH`为指定的架构,例如amd64
```bash
VERSION=4.0.3
ARCH=amd64
docker build --build-arg ARCH=${ARCH} --build-arg VERSION=${VERSION} -t easyipx:${ARCH}-${VERSION} .
```
