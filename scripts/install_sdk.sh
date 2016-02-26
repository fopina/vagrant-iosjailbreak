#!/usr/bin/env bash

set -e

ROOTSDKS=/root/sdks
SDKTAR=iPhoneOS8.1.sdk.tbz2

# check for last file on tarball...
if [ -e $THEOS/sdks/iPhoneOS8.1.sdk/Developer/Library/Frameworks/SenTestingKit.framework/Headers/SenTestingUtilities.h ]; then
  echo "iPhone 8.1 SDK already installed" >&2
else
  echo "Installing iPhone 8.1 SDK" >&2
  cd $THEOS/sdks
  if [ ! -e $ROOTSDKS/$SDKTAR ]; then
    [ -d $ROOTSDKS ] || mkdir $ROOTSDKS
    wget --quiet -O $ROOTSDKS/$SDKTAR https://jbdevs.org/sdks/dl/$SDKTAR
  fi
  tar xjpf $ROOTSDKS/$SDKTAR
fi
