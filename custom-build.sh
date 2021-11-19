#!/bin/sh
set -e
./scripts/feeds update -a -f && ./scripts/feeds install -a -f
cp config.buildinfo .config
make defconfig
make download -j8 2>&1 | tee build-dl.log
IGNORE_ERRORS=1 make -j8 2>&1 | tee build.log
