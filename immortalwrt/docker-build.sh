#!/bin/bash

PREFIX="/home/build/immortalwrt"

docker run --rm -it \
    -v ./output/bin:$PREFIX/bin -v ./output/dl:$PREFIX/dl \
    -v ./files:$PREFIX/files \
    -v ./build.sh:$PREFIX/build.sh \
    immortalwrt/imagebuilder:x86-64-openwrt-24.10.0 \
    $PREFIX/build.sh
