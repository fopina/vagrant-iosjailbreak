#!/usr/bin/env bash

set -e

# Proper linux toolchain build to be included here...

ROOTSDKS=/root/sdks

if [ -e $THEOS/toolchain/linux/iphone/bin/armv7-apple-darwin11-clang ]; then
  echo "iOS toolchain already installed" > /dev/stderr
else
  echo "Installing iOS toolchain" > /dev/stderr
  apt-get -qq install unzip

  if [ ! -e $ROOTSDKS/toolchain.zip ]; then
    [ -d $ROOTSDKS ] || mkdir $ROOTSDKS
    wget --quiet -O $ROOTSDKS/toolchain.zip https://developer.angelxwind.net/Linux/ios-toolchain_clang%2bllvm%2bld64_latest_linux_x86_64.zip
  fi

  cd $THEOS/toolchain
  unzip -qq $ROOTSDKS/toolchain.zip
fi
