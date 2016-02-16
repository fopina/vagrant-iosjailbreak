#!/usr/bin/env bash

set -e

echo "THEOS=/opt/theos" > /etc/environment

export THEOS=/opt/theos

rm -fr /opt/theos
git clone git://github.com/DHowett/theos.git $THEOS

cd /tmp
wget --quiet http://apt.saurik.com/debs/mobilesubstrate_0.9.6011_iphoneos-arm.deb
mkdir substrate
dpkg-deb -x mobilesubstrate_*_iphoneos-arm.deb substrate
mv substrate/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate $THEOS/lib/libsubstrate.dylib
mv substrate/Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h $THEOS/include/substrate.h

rm -fr /tmp/substrate /tmp/*.deb


grep THEOS /home/vagrant/.profile > /dev/null || echo PATH=\"\$THEOS/bin:\$PATH\" >> /home/vagrant/.profile
