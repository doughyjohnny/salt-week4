#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -e
#
#
# Author: Alan Guit
# Email: alanguit@tuta.io
# Version: 0.1
#
#
# Description: Installation script Salt Minion
#
#


# Download saltstack bootstrap install script
curl -L https://bootstrap.saltstack.com -o install_salt.sh

# Install Salt Minion
master_ip="$(ip neigh | awk '{print $1}' | head -n 2 | tail -n 1)"
sudo sh install_salt.sh -P

# Salt Master location
sudo sed -i "16cmaster: $master_ip" /etc/salt/minion

# Restart Minion daemon
sudo systemctl restart salt-minion

# Verify local key
sudo salt-call key.finger --local
