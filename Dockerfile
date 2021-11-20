FROM        debian:10
# Podman compatible:
# FROM        docker.io/debian:10
# Or set 'unqualified-search-registries' to include 'docker.io' in your /etc/containers/registries.conf file.

# Stolen in part from here: https://git.openwrt.org/?p=buildbot.git;a=blob;f=docker/buildworker/Dockerfile;h=5219f92e0f50fa08fadecc5576b6c7d6216e0a6a;hb=46c1b080d3eadebbb504150788ddd2d9424eb28f

USER root

RUN \
	apt-get update && \
	apt-get install -y \
		build-essential \
		ccache \
		curl \
		gawk \
		gcc-multilib \
		genisoimage \
		git-core \
		gosu \
		libdw-dev \
		libelf-dev \
		libncurses5-dev \
		locales \
		pv \
		pwgen \
		python \
		python3 \
		python3-pip \
		qemu-utils \
		rsync \
		signify-openbsd \
		subversion \
		swig \
		unzip \
		wget && \
	apt-get clean && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN useradd -ms /bin/bash buildbot
USER buildbot

WORKDIR /pwd

VOLUME [ "/pwd" ]

CMD [ "./custom-build.sh" ]

# Running:
# Checkout the desired Openwrt branch locally.
# Copy this Dockerfile and the custom-build.sh file to the Openwrt directory.
# Run using podman:
#   podman build -t openwrt-builder .
#   podman run -i --userns=keep-id -v $PWD:/pwd -t openwrt-builder 
# Now that you're in the build container, simply run the custom-build.sh script
#   chmod +x custom-build.sh # if necessary
#   ./custom-build.sh
# Feel free to modify the custom-build.sh file to suite your tastes.

