### Guide
###### Install docker and other support software
```
#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc ack tmux ncdu -y
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.27.3/yq_linux_amd64 && chmod +x /usr/local/bin/yq
apt update && apt install git sudo unzip wget -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
###### Create folder and copy 2 file docker-compose.yaml + .env inside each folder
```
cd $HOME
mkdir node1
cd node1
wget -O docker-compose.yaml https://raw.githubusercontent.com/owlstake/testnet/main/subspace/docker-compose.yaml
wget -O .env https://raw.githubusercontent.com/owlstake/testnet/main/subspace/.env
```
###### After finished download, you need to change variable inside file .env
###### each file .env should be another ports, another node name, another reward address
```
nano .env
```
###### Some command
###### start a node
```
docker compose up -d
```
###### show all docker running
```
docker ps
```
###### show logs
```
docker compose logs -f --tail=100 | grep <container-name>
```
###### stop a node
```
docker compose down
```

### If you want run the second node or n node, just change the code here, node2 --> noden
```
cd $HOME
mkdir node2
cd node2
wget -O docker-compose.yaml https://raw.githubusercontent.com/owlstake/testnet/main/subspace/docker-compose.yaml
wget -O .env https://raw.githubusercontent.com/owlstake/testnet/main/subspace/.env

Change ports, nodename, reward address inside .env file
nano .env

docker compose up -d
```
