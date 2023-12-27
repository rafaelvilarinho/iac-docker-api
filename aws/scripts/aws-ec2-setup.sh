#!/bin/bash
set -ex
cloud-init status --wait

# Docker install
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release zip

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt -y install docker-ce docker-ce-cli containerd.io

# Deploy NodeJS API
sudo docker run -d -p 8001:8001 --name docker-api-nodejs rafaelvilarinho/docker-api-nodejs