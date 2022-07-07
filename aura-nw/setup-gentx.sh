#!/bin/bash
# update nodename
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
  echo 'export CHAIN_ID='euphoria-1 >> $HOME/.bash_profile
fi
source ~/.bash_profile
echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$SEI_CHAIN_ID\e[0m"
echo '================================================='
sleep 2
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y
echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux -y
# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
# download binary
cd $HOME
sudo rm -rf aura
git clone https://github.com/aura-nw/aura
cd aura
git checkout euphoria
make
# copy binary
sudo mv ~/go/bin/aurad /usr/local/bin/aurad
source ~/.bash_profile
# config
aurad config chain-id $CHAIN_ID
aurad init $NODENAME --chain-id $CHAIN_ID
aurad keys add $WALLET


# set var
if [ ! $NODENAME ]; then
	read -p "Enter password: " PASSWORD
	echo 'export PASSWORD='$PASSWORD >> $HOME/.bash_profile
fi
#PASSWORD=********
echo -e "${PASSWORD}\n"| WALLET_ADDRESS=$(aurad keys show $WALLET -a)
echo -e "${PASSWORD}\n"| VALOPER_ADDRESS=$(aurad keys show $WALLET --bech val -a)
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
echo $WALLET_ADDRESS
echo $VALOPER_ADDRESS

# Download genesis
curl -s https://raw.githubusercontent.com/aura-nw/testnets/main/euphoria-1/pre-genesis.json >~/.aura/config/genesis.json
aurad add-genesis-account $WALLET_ADDRESS 3600000000ueaura
aurad gentx $WALLET 3600000000ueaura --commission-max-change-rate "0.01" --commission-max-rate "0.2" --commission-rate "0.07" --min-self-delegation "1" --moniker $NODENAME --website="https://owlstake.com" --details="Trusted PoS Blockchain Validator" --chain-id $CHAIN_ID
echo "your genttx"
echo "##############"
echo /root/.aura/config/gentx/*
echo "##############"
echo "Plz backup ~/.aura/config folder"
