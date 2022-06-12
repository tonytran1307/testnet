# Autoinstall script for Clan-network
## Testnet detail
- Network Chain ID: playstation-2
- Denom: uclan
- Cosmos explorer
```
https://testnet.explorer.testnet.run/Clan%20Network/staking
https://secretnodes.com/clan/chains/playstation-2/validators
https://stake-testnet.clan.network/
```
- https://docs.clan.network/general/about-clan-network
- Faucet: https://faucet-testnet.clan.network/
## Minimum Hardware Requirements
- 4GB RAM
- 50GB+ of disk space
- 2 Cores (modern CPU's)
## How to
#### You can setup your clan-network fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O clan.sh https://raw.githubusercontent.com/owlstake/testnet/main/clan-network/clan.sh && chmod +x clan.sh && ./clan.sh
```
## Post installation
##### When installation is finished please load variables into system
```
source $HOME/.bash_profile
```
##### Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
cland status 2>&1 | jq .SyncInfo
```
##### To check logs
```
journalctl -u cland -f -o cat
```
## Create wallet
##### To create new wallet you can use command below. Don’t forget to save the mnemonic
```
cland keys add $WALLET
```
## Create validator
```
cland tx staking create-validator \
  --amount 1000000uclan \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "1" \
  --commission-rate "1" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker $NODENAME \
  --fees 5550uclan
  --chain-id $CHAIN_ID \
  --identity=6B73E2068E0C0C4C \
  --website="https://owlstake.com" \
  --details="Trusted PoS Blockchain Validator. Find me at Telegram: https://t.me/owlstakeann or https://t.me/owlstakechat"
```

#### delete the node
```
systemctl stop cland
systemctl disable cland
rm /etc/systemd/system/clan* -rf
rm $(which cland) -rf
rm $HOME/.clan* -rf
rm $HOME/clan-network -rf
```
