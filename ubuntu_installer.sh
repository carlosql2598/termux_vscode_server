#!/usr/bin/env bash

set -euo pipefail
yes | pkg update && yes | pkg upgrade
termux-setup-storage
pkg install wget openssl-tool proot -y
pkg install proot-distro -y
proot-distro install ubuntu
echo "proot-distro login ubuntu" >> $PREFIX/bin/ubuntu
chmod +x $PREFIX/bin/ubuntu
ubuntu
apt update && apt upgrade -y
apt install wget -y