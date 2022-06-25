#!/bin/bash
# update
sudo apt update && sudo apt upgrade -y
# packages
sudo apt install curl build-essential git wget jq make gcc tmux libclang-dev clang -y
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
cp target/release/pcli /root/.cargo/bin/
mkdir $HOME/.local
cargo build --release --bin pd
cp target/release/pd /root/.cargo/bin/
cd $HOME
wget https://github.com/tendermint/tendermint/releases/download/v0.35.7/tendermint_0.35.7_linux_amd64.tar.gz
tar -xzvf tendermint_0.35.7_linux_amd64.tar.gz
chmod +x tendermint
cp tendermint /root/.cargo/bin/
cd penumbra
cargo run --bin pd --release -- testnet join
export RUST_LOG="warn,pd=debug,penumbra=debug"
cargo run --bin pd --release -- start --home ~/.penumbra/testnet_data/node0/pd

#another tmux window
tendermint start --home ~/.penumbra/testnet_data/node0/tendermint



