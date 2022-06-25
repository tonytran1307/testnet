#!/bin/bash
sudo systemctl stop gear-node
sudo systemctl disable gear-node
sudo rm -rf /root/.local/share/gear-node
sudo rm /etc/systemd/system/gear-node.service
sudo rm /root/gear-node
