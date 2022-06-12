#!/bin/bash
echo "=================================================="
echo -e "\033[0;35m"
echo "..................................................";
echo ".....................,,,::,,,,....................";
echo "...............,;*%S#@@@@@@@@#S%*;,...............";
echo "............:+S@@@#S?*+;;;;+*?%#@@@S*:............";
echo "..........;%@@#?+:..............,;?#@@S+,.........";
echo "........;S@@%;,.....................:?@@#+........";
echo "......,?@@%:..........................:?@@S:......";
echo "..;?:.:?S+..............................;S%;.,**..";
echo "..,%@S?;:,...............................:;*S@#:..";
echo "....+#@@@#S%?*+;:::,,,,,...,,,,,::;+*?%S#@@@@?,...";
echo "...,:,;%#@@@@@@@@@@@@###*+S##@@@@@@@@@@@@@%+,::...";
echo "...+@S:.,:*%#@@@@@@@@@@@@@@@@@@@@@@@@#S*;,.,S@?...";
echo "...*@@;....,++*%@@@@@@@@@@@@@@@@@@S*++,....:@@%...";
echo "...+@@+....,#@;.,;?#@@@@@@@@@@@%+,.,#@:....:@@?...";
echo "...:@@%.....;#@?:..,+#@@@@@@#*,..,+#@+.....*@@+...";
echo "....%@@;.....,*###SS%:*@@@@?:?SSS##?:.....,#@#,...";
echo "....,#@#:.......:;;;;,.;#@+.,;;;;:,......,S@@;....";
echo ".....:#@#;..............;*..............:S@@+.....";
echo "......:S@@?,..........................,*@@#;......";
echo "........*#@@?:......................,*#@@?,.......";
echo ".........,*#@@%+:,...............,+%@@@?:.........";
echo "...........,;%#@@#%*+;::,,::;+*%#@@@%+,...........";
echo "..............,:+%S@@@@@@@@@@@@#%*;,..............";
echo "...................,,:;;;;;;::,...................";
echo "..................................................";
echo "..........Power by https://owlstake.com...........";
echo -e "\e[0m"
echo "=================================================="

sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=playstation-2" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo 'Your node name: ' $NODENAME
echo 'Your wallet name: ' $WALLET
echo 'Your chain name: ' $CHAIN_ID
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux -y

# install go
ver="1.18.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/ClanNetwork/clan-network && cd clan-network
git checkout v1.0.4-alpha
make install

# config
cland config chain-id $CHAIN_ID
cland config keyring-backend file

# init
cland init $NODENAME --chain-id $CHAIN_ID

# download genesis
wget -qO $HOME/.clan/config/genesis.json "https://raw.githubusercontent.com/ClanNetwork/testnets/main/$CHAIN_ID/genesis.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uclan\"/" $HOME/.clan/config/app.toml

# set peers and seeds
# SEEDS=$(curl -sL https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7776-1/seeds.txt | tr '\n' ',')
PEERS=$(curl -sL https://raw.githubusercontent.com/ClanNetwork/testnets/main/playstation-2/persistent-peers.txt | tr '\n' ',')
#sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.uptickd/config/config.toml
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.clan/config/config.toml

# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.clan/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.clan/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.clan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.clan/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.clan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.clan/config/app.toml

# sync using State Sync
#SNAP_RPC1="http://peer0.testnet.uptick.network:26657" \
#&& SNAP_RPC2="http://peer1.testnet.uptick.network:26657"
#LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height) \
#&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)) \
#&& TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
#sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
#s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
#s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
#s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.uptickd/config/config.toml

# reset
cland tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/cland.service > /dev/null <<EOF
[Unit]
Description=clan
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cland) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable cland
sudo systemctl restart cland

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u cland -f -o cat\e[0m'
echo -e 'To check sync status: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
