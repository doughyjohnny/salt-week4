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
[[ $EUID -ne 0 ]] && echo "This script must be run as root" 2>&1

echo "Configuring static IP address..."
sleep 1
echo "Please enter the following..."
sleep 1
read -p "Interface: " interface
echo ""
read -p "IP address: " ipaddress
echo ""
read -p "Default Gateway: " gateway
echo ""

cat <<EOT >> /etc/netplan/01-netcfg.yaml
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
 version: 2
 renderer: networkd
 ethernets:
   "$interface":
     dhcp4: no
     dhcp6: no
     addresses: ["$ipaddress"/24]
     gateway4: "$gateway"
     nameservers:
       addresses: [8.8.8.8,8.8.4.4]
EOT

# Apply new settings to networkd
sudo netplan apply
