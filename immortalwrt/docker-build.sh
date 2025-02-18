#!/bin/bash

: "${MIRROR_URL:="https://mirror.nju.edu.cn/immortalwrt"}"
: "${VERSION:="openwrt-24.10.0"}" # or "snapshot"

WORK_DIR="$(pwd)"
BUILD_DIR="/home/build/immortalwrt"
IMAGE="immortalwrt/imagebuilder:x86-64-$VERSION"

docker run --rm -it --net=host \
    -v "$WORK_DIR/bin:$BUILD_DIR/bin" \
    -v "$WORK_DIR/files:$BUILD_DIR/files:ro" \
    -v "$WORK_DIR/build.sh:$BUILD_DIR/build.sh:ro" \
    -e "MIRROR_URL=$MIRROR_URL" \
    "$IMAGE" $BUILD_DIR/build.sh
