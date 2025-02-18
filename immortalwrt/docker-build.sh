#!/bin/bash

: "${VERSION:="openwrt-24.10.0"}" # or "snapshot"

IMAGE="immortalwrt/imagebuilder:x86-64-$VERSION"
BUILD_DIR="/home/build/immortalwrt"
WORK_DIR="$(pwd)"

docker run --rm -it --net=host \
    -v "$WORK_DIR/bin:$BUILD_DIR/bin" \
    -v "$WORK_DIR/files:$BUILD_DIR/files:ro" \
    -v "$WORK_DIR/build.sh:$BUILD_DIR/build.sh:ro" \
    "$IMAGE" $BUILD_DIR/build.sh
