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


cd install-config-files

sh install-salt-master.sh

cd ..

sudo cp -r salt /srv/
