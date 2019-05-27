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
# Description: Init script
#

# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo "This script must be run as root" 2>&1

cd install-config-files

sh initial-setup-ubuntu-server.sh
sh configure-static-ip.sh
sh install-salt-master.sh



cd ..

sudo cp -r salt /srv/
