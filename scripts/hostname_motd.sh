#!/usr/bin/env bash

set -e

cat <<EOF > /etc/motd

Welcome to JBDev VM.
Report issues in https://github.com/fopina/vagrant-iosjailbreak

EOF

echo "jailbreakdev" > /etc/hostname
sed -i 's/^127.0.1.1.*/127.0.1.1\tjailbreakdev/' /etc/hosts
hostname jailbreakdev
