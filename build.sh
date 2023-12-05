#!/bin/bash

set -ex

cd $(dirname $0)
ROOT=$(pwd)

SOURCE_ROOT="$(pwd)/source"
BUILD_PREFIX="$ROOT/output"

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -c | --clean)
        rm -rf "$SOURCE_ROOT"
        rm -rf "$BUILD_PREFIX"
        shift
        ;;
    -p | --prefix)
        BUILD_PREFIX="$2"
        shift
        shift
        ;;
    *) 
        echo "Unknown option $1"
        exit 1
        shift 
        ;;
    esac
done

mkdir -p "$SOURCE_ROOT"
mkdir -p "$BUILD_PREFIX"

export PKG_CONFIG_PATH="$BUILD_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"

function build_avahi() {
    cd "$SOURCE_ROOT"
    TAR_FILE="avahi-0.8.tar.gz"
    wget https://github.com/avahi/avahi/releases/download/v0.8/avahi-0.8.tar.gz -O $TAR_FILE
    tar -xvf $TAR_FILE
    rm -rf $TAR_FILE
    cd avahi-0.8
    ./configure --prefix=$BUILD_PREFIX \
        --disable-gtk --disable-gtk3 \
        --disable-mono --disable-qt5 \
        --disable-python
    make -j$(nproc)
    make install
}
build_avahi

GIT_REPO_LIST=(
    "https://github.com/libimobiledevice/libplist"
    "https://github.com/libimobiledevice/libimobiledevice-glue"
    "https://github.com/libimobiledevice/libusbmuxd"
    "https://github.com/libimobiledevice/libimobiledevice"
    "https://github.com/libimobiledevice/usbmuxd"
    "https://github.com/tihmstar/libgeneral"
    "https://github.com/tihmstar/usbmuxd2"
)

function fetch_source() {
    cd "$SOURCE_ROOT"
    dir_name=$(echo $1 | awk -F '/' '{print $NF}' | sed -e 's/.git//g')
    if [ -d $dir_name ]; then
        cd $dir_name
        git pull
    else
        git clone $1
    fi
    cd "$SOURCE_ROOT/$dir_name"
    git submodule init
    git submodule update
    git clean -fdx
    git reset --hard
}

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

function build_source() {
    cd "$SOURCE_ROOT"
    dir_name=$(echo $1 | awk -F '/' '{print $NF}' | sed -e 's/.git//g')
    cd "$dir_name"
    ./autogen.sh --prefix="$BUILD_PREFIX"
    make -j$(nproc)
    make install
}

for repo in ${GIT_REPO_LIST[@]}; do
    fetch_source $repo
    build_source $repo
done

echo "Build Success!"


