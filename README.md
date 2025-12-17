# 内网穿透 easyipx部署

## 官方部署方式

请参考 [easyipx 官方文档](https://www.yuque.com/xinu/notes/mzagfszkmy1gecaf?singleDoc) 获取更多信息。

## Docker镜像启动方式

### 编排模板

1Panel面板中```/opt/1panel/apps/easyipx/ssl```是你放置ssl证书的位置：
```
services:
  easyipx:
    # 直接指定镜像（amd64+4.0.3，根据你的系统修改ARCH）
    image: registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:amd64-4.0.3
    container_name: easyipx
    restart: always
    network_mode: host
    environment:
      - TZ=Asia/Shanghai
      - PORT=8088  # 通道使用的端口
      - TOKEN=your_custom_token  # 必须修改为自定义token（如：123456abc）
      - TUNNEL_TLS=false  # 是否开启通道加密
      #- TUNNEL_PEM_FILE=/opt/easyipx/ssl/server.pem  # 启用TLS时取消注释并配置
      #- TUNNEL_KEY_FILE=/opt/easyipx/ssl/server.key
      - HTTP_PORT=6080  # HTTP服务端口
      #- HTTPS_PORT=6443  # 启用HTTPS时取消注释
      #- HTTP_PEM_FILE=/opt/easyipx/ssl/http.pem
      #- HTTP_KEY_FILE=/opt/easyipx/ssl/http.key
      - PORT_RANGE=1024-49151  # 动态端口范围
    volumes:
      - /opt/1panel/apps/easyipx/ssl:/opt/easyipx/ssl/  # 证书存储目录（宿主机路径）

```

宝塔面板中```/www/wwwroot/easyipx/ssl```是你放置ssl证书的位置：
```
services:
  easyipx:
    # 直接指定镜像（amd64+4.0.3，根据你的系统修改ARCH）
    image: registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:amd64-4.0.3
    container_name: easyipx
    restart: always
    network_mode: host
    environment:
      - TZ=Asia/Shanghai
      - PORT=8088  # 通道使用的端口
      - TOKEN=your_custom_token  # 必须修改为自定义token（如：123456abc）
      - TUNNEL_TLS=false  # 是否开启通道加密
      #- TUNNEL_PEM_FILE=/opt/easyipx/ssl/server.pem  # 启用TLS时取消注释并配置
      #- TUNNEL_KEY_FILE=/opt/easyipx/ssl/server.key
      - HTTP_PORT=6080  # HTTP服务端口
      #- HTTPS_PORT=6443  # 启用HTTPS时取消注释
      #- HTTP_PEM_FILE=/opt/easyipx/ssl/http.pem
      #- HTTP_KEY_FILE=/opt/easyipx/ssl/http.key
      - PORT_RANGE=1024-49151  # 动态端口范围
    volumes:
      - /www/wwwroot/easyipx/ssl:/opt/easyipx/ssl/  # 证书存储目录（宿主机路径）

```
面板中部署后直接新建站点，反向代理```http://127.0.0.1:6080```即可

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

#### 支持的-e参数

 参数              | 默认值        | 描述                                                  
-----------------|------------|-----------------------------------------------------
 PORT            | 8088       | 通道使用的端口，按需修改                                        
 TOKEN           | your_token | 签名使用的token 不要泄露出去,建议修改                              
 TUNNEL_TLS      | false      | 是否开启通道加密。如果设置为true 则下面的两个文件必须配置                     
 TUNNEL_PEM_FILE |            | 与程序本体的相对路径或绝对路径皆可                                   
 TUNNEL_KEY_FILE |            | 与程序本体的相对路径或绝对路径皆可                                   
 HTTP_PORT       | 6080       | http端口，按需修改                                         
 HTTPS_PORT      | 6443       | https端口，按需修改,请注意，如果是nginx转发的，这里的证书不需要配置，证书配置在nginx上 
 HTTP_PEM_FILE   |            | https需要的证书, 如果未配置，则https端口不会开通                      
 HTTP_PEM_FILE   |            | https需要的证书, 如果未配置，则https端口不会开通                      
 HTTP_KEY_FILE   |            | https需要的证书，如果未配置，则https端口不会开通                       
 PORT_RANGE      | 1024-49151 | 这里的端口范围只是为了方便客户端设置端口，不会全部占用，用到哪个开哪个                 

#### 支持的版本

 镜像版本        | 镜像地址                                                               | 镜像描述          
-------------|--------------------------------------------------------------------|---------------
 amd64-4.0.3 | registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:amd64-4.0.3 | linux/amd64架构 
 arm64-4.0.3 | registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:arm64-4.0.3 | linux/arm64架构 
 amd64-3.2.0 | registry.cn-shanghai.aliyuncs.com/yhliu-public/easyipx:amd64-3.2.0 | linux/amd64架构 

### 自行构建

1. **拉取源码**

```bash
git clone git@github.com:nicheng-he/easyipx-docker.git
```

2. **从 [easyipx 官方仓库](https://github.com/imxiny/easyipx/) 下载对应版本的 `easyipx` 二进制文件**

- 并放置第一步目录内

3. **构建镜像**

- 设置`--version`为你需要的版本,例如4.0.3
- 设置`--arch`为指定的架构,例如amd64

```bash
docker_build.sh --version=4.0.3 --arch=amd64
```
