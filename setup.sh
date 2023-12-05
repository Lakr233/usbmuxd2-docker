#!/bin/bash

REQUIRED_PACKAGE=(
    "ca-certificates"
    "build-essential"
    "clang"
    "cmake"
    "automake"
    "pkg-config"
    "checkinstall"
    "autoconf"
    "git"
    "libtool-bin"
    "libudev-dev"
    "libusb-dev"
    "libusb-1.0-0-dev"
    "libxml2-dev"
    "libevent-dev"
    "libssl-dev"
    "libdaemon-dev"
    "libglib2.0-dev"
    "libdbus-1-dev"
    "libexpat-dev"
    "libgdbm-dev"
    "doxygen"
    "cython3"
    "python3"
    "python3-dev"
    "python-is-python3"
    "expat"
    "dbus"
    "wget"
    "nss-mdns"
)
if ! [ -x "$(command -v apt)" ]; then
    echo "apt is not installed, please install apt first"
    exit 1
fi
apt install -y --no-install-recommends ${REQUIRED_PACKAGE[@]}

update-ca-certificates
