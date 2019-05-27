#!/usr/bin/env bash
set -e
#
# Description: Configure static IP address script
#
# Author: Alan Guit
# Email: alanguit@tuta.io
# Version: 0.1
#
#
# Make sure only root can run our script
if [ $EUID -ne 0 ]; then
  echo "This script must be run as root" 2>&1
  exit 1
fi

echo "Configuring static IP address..."
sleep 1
echo "Please enter the following..."
sleep 1
read -p "Interface: " int
echo ""
read -p "IP address: " ip
echo ""
read -p "Default Gateway: " gate
echo ""

cat <<EOT >> /etc/network/interfaces
auto "$int"
iface "$int" inet static
    address "$ip"/24
    gateway "$gate"
EOT
