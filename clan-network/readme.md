#### Clan network


#### delete the node
```
systemctl stop cland
systemctl disable cland
rm /etc/systemd/system/clan* -rf
rm $(which cland) -rf
rm $HOME/.clan* -rf
rm $HOME/clan-network -rf
```
