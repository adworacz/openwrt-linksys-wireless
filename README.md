# openwrt-linksys-wireless
This repo houses various scripts, Dockerfiles, and packages to fix the wifi cutouts
on Linksys WRT\* devices.

All of this comes from the work done on the OpenWrt thread:

<https://forum.openwrt.org/t/users-needed-to-test-wi-fi-stability-on-linksys-wrt3200acm-wrt32x-on-openwrt-21-02>

Some additional context can be found here:

<https://austindw.com/wrt3200acm-wrt32x-builds/#context>

Known effected devices:
* WRT3200ACM
* WRT32X

Other devices may be effected. The community is still confirming.

## Modules
Simply download the kernel modules for the corresponding OpenWrt version from under the `releases` directory.

TODO: Script this install later...

## Build quickstart, using Podman
```
git clone https://github.com/adworacz/openwrt-linksys-wireless
cd openwrt-linksys-wireless

# Build the container using Podman
podman build -t openwrt-builder .

# Run the container, which should build official images and
# automatically extract the necessary kmod packages into the 'releases' directory.
podman run -it --userns=keep-id -v $PWD:/pwd openwrt-builder

# If you want to use your freshly built image, instead of downgrading artifacts,
# simply get the image from underneath the `openwrt/bin/targets/mvebu/cortexa9/` directory.

# Enjoy!
```

