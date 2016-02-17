#!/usr/bin/env bash

set -e

# check for last file on tarball...
if [ -e $THEOS/sdks/iPhoneOS8.1.sdk/Developer/Library/Frameworks/SenTestingKit.framework/Headers/SenTestingUtilities.h ]; then
  echo "iPhone 8.1 SDK already installed" > /dev/stderr
else
  echo "Installing iPhone 8.1 SDK" > /dev/stderr
  cd $THEOS/sdks
  wget --quiet http://iphone.howett.net/sdks/dl/iPhoneOS8.1.sdk.tbz2
  tar xjpf iPhoneOS8.1.sdk.tbz2
  rm iPhoneOS8.1.sdk.tbz2
fi
