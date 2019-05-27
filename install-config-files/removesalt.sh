#!/bin/bash

sudo apt remove --purge -y salt-common salt-minion salt-master
sudo apt autoremove -y
sudo rm -rf /etc/salt
