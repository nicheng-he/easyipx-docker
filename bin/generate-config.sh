#!/bin/sh

# 生成配置文件
envsubst < ./config/config.json.template > ./config/config.json

# 打印生成的配置文件
cat ./config/config.json
