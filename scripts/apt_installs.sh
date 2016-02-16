#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get -qq dist-upgrade

apt-get install git perl curl
