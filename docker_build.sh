#!/bin/bash

# 日志
log() {
  echo $2 "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}


# 初始化变量
PUSH_REGISTRY=false
VERSION=""
ARCH="amd64"

# 读取参数
shift $((OPTIND -1))
for arg in "$@"; do
  case $arg in
    --version=*)
      VERSION="${arg#*=}"
      shift
      ;;
    --arch=*)
      ARCH="${arg#*=}"
      shift
      ;;
    --push)
      PUSH_REGISTRY=true
      shift
      ;;
  esac
done

# 输出读取到的参数
log "Arch: $ARCH"
log "Version: $VERSION"

if [ -z "$VERSION" ]; then
  log "Error: VERSION is not set" 1>&2
  exit 1
fi

if [ -z "$ARCH" ]; then
  log "Error: ARCH is not set" 1>&2
  exit 1
fi

# 镜像名称
IMAGE_TAG="easyipx:${ARCH}-${VERSION}"

# 构建镜像
docker build \
  --platform linux/"${ARCH}" \
  --build-arg ARCH="${ARCH}" \
  --build-arg VERSION="${VERSION}" \
  -t "${IMAGE_TAG}" .

# 判断是否需要推送镜像
if [ "$PUSH_REGISTRY" = true ]; then
  REGISTRY_URL="registry.cn-shanghai.aliyuncs.com"
  IMAGE_PUSH_URL="${REGISTRY_URL}/yhliu-public/${IMAGE_TAG}"

  docker tag "${IMAGE_TAG}" "${IMAGE_PUSH_URL}"
  echo "登陆Aliyun镜像仓库(此处需要仓库密码) "
  docker login --username=nicheng_he "${REGISTRY_URL}"
  log "推送镜像:${IMAGE_TAG}"
  docker push "${IMAGE_PUSH_URL}"
  log "推送镜像成功"
fi
