#!/usr/bin/bash
set -eux
apt-get update
for package in $(cat install_packages | grep -v '^ *#' | sed 's/#.*$//')
do
    apt-get install -y $package
done
./run_on_startup.sh
/usr/sbin/sshd -D