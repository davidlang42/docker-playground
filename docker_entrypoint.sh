#!/usr/bin/bash
set -eux

# set user's password from environment variables
if [ -z "${PLAYER_PASSWORD}" ]; then
    echo "Must set environment variable PLAYER_PASSWORD"
    exit 1 # failed
fi
echo "$PLAYER_USERNAME:$PLAYER_PASSWORD" | chpasswd

# install additional packages
apt-get update
for package in $(cat install_packages | grep -v '^ *#' | sed 's/#.*$//')
do
    apt-get install -y $package
done

# run startup script
./run_on_startup.sh

# start the ssh server
/usr/sbin/sshd -D