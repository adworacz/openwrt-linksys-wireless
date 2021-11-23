#!/usr/bin/env bash
set -e

# Original instructions: https://forum.openwrt.org/t/users-needed-to-test-wi-fi-stability-on-linksys-wrt3200acm-wrt32x-on-openwrt-21-02/101700/508

VERSION='21.02.1'
RELEASE_DIR="releases/$VERSION-patched-mac80211-5.10"
MAKE_JOBS=16

# Checkout OpenWrt (if necessary)
[ ! -d openwrt ] && git clone https://git.openwrt.org/openwrt/openwrt.git

# Add mac80211 5.8+ patch
cp patches/550-mac80211-ag-tx-account-for-ssn-change.patch openwrt/package/kernel/mac80211/patches/subsys/

cd openwrt
# Checkout specific branch
git checkout "v$VERSION"

# Download and prep all feeds.
./scripts/feeds update -a -f && ./scripts/feeds install -a -f

# Get the same build config used by the OpenWrt builder fleet. 
wget "https://downloads.openwrt.org/releases/$VERSION/targets/mvebu/cortexa9/config.buildinfo"
cp config.buildinfo .config

# Make it so!
make defconfig
make download -j"$MAKE_JOBS" 2>&1 | tee build-dl.log
make -j"$MAKE_JOBS" 2>&1 | tee build.log

# Copy artifacts to the "release/$VERSION" folder, and generate checksums
mkdir -p "$RELEASE_DIR"
cp openwrt/bin/targets/mvebu/cortexa9/packages/kmod-mac80211_* "$RELEASE_DIR"
cd "$RELEASE_DIR"
sha256sum * > sha256sums

