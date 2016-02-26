#!/usr/bin/env bash

set -e

if [ -e $THEOS/toolchain/linux/iphone/bin/armv7-apple-darwin11-clang ]; then
  echo "iOS toolchain already installed" >&2
else
  echo "Installing iOS toolchain" >&2

  export DEBIAN_FRONTEND=noninteractive
  ROOTSDKS=/root/sdks

  apt-get -qq install clang build-essential

  if [ ! -e $ROOTSDKS/toolchain.tbz2 ]; then
    [ -d $ROOTSDKS ] || mkdir $ROOTSDKS
    wget --quiet -O $ROOTSDKS/toolchain.tbz2 https://github.com/fopina/vagrant-iosjailbreak/releases/download/v0.0/toolchain.tbz2
  fi

  cd $THEOS/toolchain
  tar xjpf $ROOTSDKS/toolchain.tbz2
  ln -s $THEOS/toolchain/linux/iphone/bin/ldid $THEOS/bin/ldid
fi
