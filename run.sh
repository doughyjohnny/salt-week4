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
# Description: Script that runs installation and configuration scripts
#

# Extract scripts archive
tar -xzf scripts.tar
cd scripts

# Nagios + Nagios-plugins on first server
sudo chmod +x install-nagios.sh
sudo chmod +x install-nagios-plugins.sh

sh install-nagios.sh
sh install-nagios-plugins.sh

# LAMP stack + NRPE service on second server
sudo chmod +x install-lamp-stack.sh
sudo chmod +x install-nrpe-remote.sh

sh install-lamp-stack.sh
sh install-nrpe-remote.sh

# Add remote host to Nagios server on first server
sudo chmod +x add-nagios-host.sh
sh add-nagios-host.sh

# Configure rsyslog server on first server
sudo chmod +x configure-rsyslog-server.sh
sh configure-rsyslog-server.sh

# Configure rsyslog client on second server
sudo chmod +x configure-rsyslog-client.sh
sh configure-rsyslog-client.sh
