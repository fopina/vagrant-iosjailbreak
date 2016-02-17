#!/usr/bin/env bash

set -e

apt-get -qq install subversion

svn checkout http://ios-toolchain-based-on-clang-for-linux.googlecode.com/svn/trunk/cctools-porting
cd cctools-porting/
sed -i 's/proz -k=20  --no-curses/wget/' cctools-ld64.sh
./cctools-ld64.sh
