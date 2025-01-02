#!/bin/bash

source /etc/environment

## 检查 TOEKN 是否为空
#if [ -z "$TOEKN" ]; then
#    echo "Token is not set. Generating a random token..."
#    # 生成一个随机字符串作为 TOEKN
#    TOEKN=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
#    echo "Generated Token: $TOEKN"
#    echo "TOEKN=$TOEKN" >> /etc/environment
#else
#    echo "Get Token: $TOEKN"
#fi

# 生成配置文件
envsubst < ./config/config.json.template > ./config/config.json

# 打印生成的配置文件
cat ./config/config.json
