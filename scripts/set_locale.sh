#!/usr/bin/env bash

set -e

[[ -n $1 ]] || exit 0

grep ^$1 /etc/locale.gen &> /dev/null && exit 0

sed -i "s/^# $1/$1/" /etc/locale.gen
locale-gen
