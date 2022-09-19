### Hướng dẫn
###### Cài docker và các thành phần phụ
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
###### Tạo nhiều thư mục và copy 2 file docker-compose.yaml + .env vào từng thư mục
###### Đổi biến trong file .env
```
mỗi 1 file .env là port phải khác nhau
tên node khác
địa chỉ nhận reward khác
```
###### docker compose up -d
###### docker ps
###### docker compose logs -f --tail=100 | grep <container-name>
###### Xóa docker compose down
