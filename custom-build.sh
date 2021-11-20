#!/usr/bin/env bash
set -e

# Original instructions: https://forum.openwrt.org/t/users-needed-to-test-wi-fi-stability-on-linksys-wrt3200acm-wrt32x-on-openwrt-21-02/101700/508

VERSION='21.02.1'
RELEASE_DIR="releases/$VERSION"
MAKE_JOBS=16

# Checkout OpenWrt and switch to the associated version branch.
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
git checkout "v$VERSION"

# Modify mac80211 packages
rm -rf package/kernel/{mac80211,ath10k-ct,mt76,rtl8812au-ct}
git checkout d1100c76b33ff68c6db0f5fa31a26532bdbb15c4 -- package/kernel/{mac80211,ath10k-ct,mt76,rtl8812au-ct}
rm -f package/kernel/mac80211/patches/ath/551-ath9k_ubnt_uap_plus_hsr.patch

# Download and prep all feeds.
./scripts/feeds update -a -f && ./scripts/feeds install -a -f

# "batman-adv fails to compile because of header mixup involving a mac80211-installed header." - cotequeiroz
./scripts/feeds uninstall batman-adv

# Get the same build config used by the OpenWrt builder fleet. 
wget "https://downloads.openwrt.org/releases/$VERSION/targets/mvebu/cortexa9/config.buildinfo"
cp config.buildinfo .config

# Make it so!
make defconfig
make download -j"$MAKE_JOBS" 2>&1 | tee build-dl.log
make -j"$MAKE_JOBS" 2>&1 | tee build.log

# Copy artifacts to the "release/$VERSION" folder, and generate checksums
mkdir -p "$RELEASE_DIR"
cp openwrt/bin/targets/mvebu/cortexa9/packages/{kmod-mac80211,kmod-cfg80211,kmod-mwifiex-sdio,kmod-mwlwifi}_* "$RELEASE_DIR"
cd "$RELEASE_DIR"
sha256sum * > sha256sums

# Cleanup/delete openwrt folder.
# rm -rf openwrt
