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
# Description: Installation script Salt Master
#
#

# Set initial configs
./initial-setup-ubuntu-server.sh

# Download saltstack bootstrap install script
curl -L https://bootstrap.saltstack.com -o install_salt.sh

# Install Salt Master daemon
sudo sh install_salt.sh -P -M

# Create Salt Directories
sudo mkdir -p /srv/{salt,pillar,formulas}

# Salt configuration
# Set file_roots directory
sudo sed -i '658c\file_roots:\' /etc/salt/master
sudo sed -i '659c\  base:\' /etc/salt/master
sudo sed -i '660c\    - /srv/salt\' /etc/salt/master
sudo sed -i '661c\    - /srv/formulas\' /etc/salt/master

# Set pillar_roots directory
sudo sed -i '828c\pillar_roots:\' /etc/salt/master
sudo sed -i '829c\  base:\' /etc/salt/master
sudo sed -i '830c\    - /srv/pillar\' /etc/salt/master

# Minion should connect to
sudo sed -i '16c\master: 127.0.0.1\' /etc/salt/minion

# Restart the processes
sudo systemctl restart salt-master
sudo systemctl restart salt-minion

# Get SaltMaster ip address
master_ip="$(ip addr | grep ' inet ' | awk '{print $2}' | tail -n 1 | cut -d'/' -f 1)"
minion01_ip="$(ip neigh | awk '{print $1}' | head -n 2 | tail -n 1)"

# Resolv hosts
# sudo sed -i "2c|$master_ip    master      master.local|" /etc/hosts
# sudo sed -i "3c|$minion01_ip    minion01    minion01.local|" /etc/hosts

# Create ssh-key
ssh-keygen
scp ~/.ssh/id_rsa.pub salt@saltminion01:~/.ssh/authorized_keys

# Install Salt-Minion
scp install-salt-minion.sh salt@saltminion01:~/
ssh -t salt@saltminion01 "./install-salt-minion.sh -h now"
ssh -t salt@saltminion01 "exit"

# Accept keys
sudo salt-key -a saltmaster
sudo salt-key -a saltminion01

# Test communication
sudo salt '*' test.ping
