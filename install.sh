#!/bin/bash

echo "Upgrading packages"
sudo apt update && sudo apt upgrade -y

echo "Installing docker.."
sudo apt install -y git docker docker-compose
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart
sudo systemctl enable docker

echo "Installing docker-posbox"
sudo mkdir -p /posbox
sudo chown -R $USER:$USER /posbox
git clone https://github.com/druidoo/docker-posbox.git /posbox/docker-posbox
cd /posbox/docker-posbox

echo "Building image"
sudo docker-compose up -d
