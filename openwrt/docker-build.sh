#!/bin/bash

: "${VERSION:="24.10.0"}" # or "SNAPSHOT"

IMAGE="openwrt/imagebuilder:x86-64-$VERSION"
BUILD_DIR="/builder"
WORK_DIR="$(pwd)"

docker run --rm -it --net=host \
    -v "$WORK_DIR/bin:$BUILD_DIR/bin" \
    -v "$WORK_DIR/files:$BUILD_DIR/files:ro" \
    -v "$WORK_DIR/build.sh:$BUILD_DIR/build.sh:ro" \
    "$IMAGE" $BUILD_DIR/build.sh
