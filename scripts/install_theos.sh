#!/usr/bin/env bash

set -e

THEOS=/opt/theos

if [ -d $THEOS/.git ]; then
  echo "Updating THEOS" > /dev/stderr
  cd $THEOS
  git pull
else
  echo "Installing THEOS"  > /dev/stderr
  git clone --recursive https://github.com/theos/theos $THEOS

  cd /tmp
  wget --quiet http://apt.saurik.com/debs/mobilesubstrate_0.9.6011_iphoneos-arm.deb
  mkdir substrate
  dpkg-deb -x mobilesubstrate_*_iphoneos-arm.deb substrate
  mv substrate/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate $THEOS/lib/libsubstrate.dylib
  mv substrate/Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h $THEOS/include/substrate.h

  rm -fr /tmp/substrate /tmp/*.deb
fi

cat <<EOF > /etc/profile.d/theos.sh
export THEOS=$THEOS
export PATH="\$THEOS/bin:\$PATH"
EOF
