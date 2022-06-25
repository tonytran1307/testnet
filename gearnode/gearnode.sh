#!/bin/bash
# Download binary
rm -f gear-nightly-linux-x86_64.tar.xz
wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz && \
chmod +x gear-node
./gear-node --version
# create service
sudo tee /etc/systemd/system/gear-node.service > /dev/null <<EOF
[Unit]
Description=Gear Node
After=network.target
[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node --name 'owlstake' --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
# Load the service
sudo systemctl start gear-node
sudo systemctl enable gear-node
sudo systemctl status gear-node
# show the logs
journalctl -u gear-node -fn 50
