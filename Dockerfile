FROM alpine
LABEL authors="yhliu"

ARG ARCH=amd64
ARG VERSION=4.0.3

#通道使用的端口，按需修改
ENV PORT=8088
#签名使用的token 不要泄露出去
ENV TOKEN=""

#是否开启通道加密。如果设置为true 则下面的两个文件必须配置
ENV TUNNEL_TLS=false
#与程序本体的相对路径或绝对路径皆可
ENV TUNNEL_PEM_FILE=""
#与程序本体的相对路径或绝对路径皆可
ENV TUNNEL_KEY_FILE=""

#http服务的配置
#http端口，按需修改
ENV HTTP_PORT=6080
#https端口，按需修改
ENV HTTPS_PORT=6443
#请注意，如果是nginx转发的，这里的证书不需要配置，证书配置在nginx上
#https需要的证书, 如果未配置，则https端口不会开通
ENV HTTP_PEM_FILE=""
#https需要的证书，如果未配置，则https端口不会开通
ENV HTTP_KEY_FILE=""
#这里的端口范围只是为了方便客户端设置端口，不会全部占用，用到哪个开哪个
ENV PORT_RANGE="1024-49151"

RUN apk add --no-cache gettext

# 设置工作目录
WORKDIR /opt/easyipx
# 复制配置模板文件
COPY ./config/ ./config/
# 复制生成配置文件的脚本
COPY ./bin/ ./bin/

# 根据架构复制不同的二进制文件
COPY ./easyipx-linux-${ARCH}-${VERSION} ./bin/easyipx

# 确保脚本具有可执行权限
RUN chmod +x ./bin/*.sh ./bin/easyipx
# 构建时生成配置文件
RUN ./bin/generate-config.sh
# 设置启动命令
CMD ["sh", "-c", "./bin/generate-config.sh && ./bin/easyipx -c ./config/config.json"]
