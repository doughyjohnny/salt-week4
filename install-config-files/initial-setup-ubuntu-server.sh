#!/usr/bin/env bash
set -e
#
#
# Author: Alan Guit
# Email: alanguit@tuta.io
# Version: 0.1
#
#
# Description: Initial configurations after a fresh Ubuntu server installation.
#
#
# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo "This script must be run as root" 2>&1

# Function to create new user
f_newuser() {
  read -p "Create new user? [y/n] " input
  if [ "$input" == "y" ] ; then
      read -p "Username: " name
    sudo useradd "$name"
    sudo passwd "$name"
    f_superuser "$name"
    f_switch_user "$name"
    f_generate_key "$name"
  fi
}

# Function to give user superuser privileges
f_superuser() {
  read  -p "Give user superuser privileges? [y/n] " input
    if [ "$input" == "y" ] ; then
      sudo usermod -aG sudo "$1"
    fi
}

# Function to switch user account
f_switch_user() {
  read -p "Switch to new user? [y/n] " input
  if [ "$input" == "y" ] ; then
    su - "$1"
  fi
}

# Function to check timezone
f_check_timezone() {
  date
  sleep 1
}

# Function to change timezone
f_change_timezone() {
  echo "Select new timezone"
  timedatectl list-timezones
  read -p "New timezone: " input
  sudo timedatectl set-timezone "$input"
  input=
}

# Function to generate SSH key
f_generate_key() {
  read -p "Generate ssh key? [y/n] " input
  if [ "$input" == "y" ] ; then
    ssh-keygen -t rsa -b 4096 -T ~/.ssh/"$1"-ssh_key -C "SSH key for $1"
  fi
}

### Main ###
echo "Welcome to this post-installation script for Ubuntu18.04"
echo "This script automates setting the initial configurations"

# Create a new user?
f_newuser

# Upgrade the system
sudo apt update && sudo apt upgrade -y

# Setting Up Firewall
#Allow OpenSSH firewall rule
printf "Allowing OpenSSH...\n"
printf "\n"
sleep 1
sudo ufw allow 2200/tcp
# Enable the firewall
printf "Enabling firewall...\n"
printf "\n"
sleep 1
sudo ufw enable
# Check status of the firewall
printf "Checking firewall status...\n"
printf "\n"
sleep 1
sudo ufw status

# Check servertime and timezone
while :
do
    f_check_timezone
    read -p "Is current servertime correct? [y/n] " input
    if [ "$input" == "y" ] ; then
      break
    fi
    f_change_timezone
done

# Keeping Time In Sync
sudo timedatectl set-ntp on

# Update Ubuntu
printf "\n"
printf "Updating repositories...\n"
printf "\n"
sudo apt update
printf "\n"

# Update Ubuntu
printf "\n"
printf "Checking dependencies...\n"
printf "\n"
for pkg in "curl wget git openssh-server"; do
  if [ ! -x "$(command -v "$pkg")" ]; then
    printf "Installling $pkg...\n"
    sudo apt install "$pkg"
  fi
done
printf "\n"

# Upgrading packages
printf "Upgrading packages...\n"
printf "\n"
sudo apt upgrade -y
printf "\n"


