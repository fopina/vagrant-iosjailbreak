#!/usr/bin/env bash

set -e

if [ "$(hostname)" = "jailbreakdev" ]; then
  ROOTSDKS=/root/sdks
  SDKTAR=iPhoneOS8.1.sdk.tbz2

  apt-get -qq install build-essential libssl-dev autogen automake libtool gobjc++ clang

  if [ ! -e $ROOTSDKS/$SDKTAR ]; then
    [ -d $ROOTSDKS ] || mkdir $ROOTSDKS
    wget --quiet -O $ROOTSDKS/$SDKTAR https://jbdevs.org/sdks/dl/$SDKTAR
  fi

  cd /root
  rm -fr cctools-port
  git clone https://github.com/tpoechtrager/cctools-port/
  cd cctools-port/usage_examples/ios_toolchain
  sed -i 's/tar\.bz2/tbz2/' build.sh
  ./build.sh $ROOTSDKS/$SDKTAR armv7

  cd target/bin
  for i in $(ls arm-apple-darwin11-*); do ln -s $i $(echo $i | sed -e 's/^arm-apple/armv7-apple/'); done

  cd ../..
  mkdir linux
  mv target linux/iphone
  tar cjpf /tmp/toolchain.tbz2 linux
else
  cd $(dirname $0)
  vagrant scp $0 :/tmp/
  vagrant ssh -- sudo /tmp/$0
  vagrant scp :/tmp/toolchain.tbz2 .
fi
