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

  grep ^'export THEOS_DEVICE_IP=' \$HOME/.profile > /dev/null || echo "export THEOS_DEVICE_IP=" >> \$HOME/.profile
  sed -i "s/^export THEOS_DEVICE_IP=.*/export THEOS_DEVICE_IP=\$1/" \$HOME/.profile
  export THEOS_DEVICE_IP=\$1
}

function sshi
{
  if [ -z \$THEOS_DEVICE_IP ]; then
    echo "No device defined, use setphone first"
    return 1
  fi

  ssh -l root \$THEOS_DEVICE_IP \$*
}
EOF
