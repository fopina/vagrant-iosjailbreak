#!/usr/bin/env bash

set -e

THEOS=/opt/theos

if [ -d $THEOS/.git ]; then
  echo "Updating THEOS" >&2
  cd $THEOS
  git pull
else
  echo "Installing THEOS"  >&2
  git clone --recursive https://github.com/theos/theos $THEOS
fi

cat <<EOF > /etc/profile.d/theos.sh
export THEOS=$THEOS
export PATH="\$THEOS/bin:\$PATH"

function setphone
{
  if [ -z \$1 ]; then
    echo "Usage: setphone PHONE_IP" 1>&2
    return 1
  fi

  grep ^THEOS_DEVICE_IP= \$HOME/.profile > /dev/null || echo "THEOS_DEVICE_IP=" >> \$HOME/.profile
  sed -i "s/^THEOS_DEVICE_IP=.*/THEOS_DEVICE_IP=\$1/" \$HOME/.profile
  export THEOS_DEVICE_IP=\$1
}
EOF
