#!/bin/bash

PREFIX="/builder"

docker run --rm -it \
    -v ./output/bin:$PREFIX/bin -v ./output/dl:$PREFIX/dl \
    -v ./files:$PREFIX/files \
    -v ./build.sh:$PREFIX/build.sh \
    openwrt/imagebuilder:x86-64-24.10.0 \
    $PREFIX/build.sh
