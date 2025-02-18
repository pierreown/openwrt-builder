#!/bin/bash

: "${MIRROR_URL:="https://mirror.nju.edu.cn/openwrt"}"
: "${VERSION:="24.10.0"}" # or "SNAPSHOT"

PREFIX="/builder"

docker run --rm -it --net=host \
    -v ./bin:$PREFIX/bin \
    -v ./files:$PREFIX/files \
    -v ./build.sh:$PREFIX/build.sh \
    -e MIRROR_URL="$MIRROR_URL" \
    "openwrt/imagebuilder:x86-64-$VERSION" \
    $PREFIX/build.sh
