#!/bin/bash

: "${MIRROR_URL:="https://mirror.nju.edu.cn/immortalwrt"}"
: "${VERSION:="openwrt-24.10.0"}" # or "snapshot"

PREFIX="/home/build/immortalwrt"

docker run --rm -it --net=host \
    -v ./bin:$PREFIX/bin \
    -v ./files:$PREFIX/files \
    -v ./build.sh:$PREFIX/build.sh \
    -e MIRROR_URL="$MIRROR_URL" \
    "immortalwrt/imagebuilder:x86-64-$VERSION" \
    $PREFIX/build.sh
