#!/bin/bash
# update
sudo apt update && sudo apt upgrade -y
# packages
sudo apt install curl build-essential git wget jq make gcc tmux libclang-dev -y
sudo apt-get install build-essential pkg-config libssl-dev -y
# install rush
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$HOME/.cargo/bin" >> ~/.bash_profile
source ~/.bash_profile
# download binary
cd $HOME
rm -rf penumbra
git clone https://github.com/penumbra-zone/penumbra
cd penumbra && git fetch && git checkout 020-aitne && cargo update
cargo build --quiet --release --bin pcli
