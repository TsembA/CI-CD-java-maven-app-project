#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sleep 10

#install docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.35.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose