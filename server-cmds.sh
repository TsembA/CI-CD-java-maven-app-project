#!/usr/bin/env bash

# Install Docker & Docker Compose
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sleep 5

DOCKER_COMPOSE_VERSION="v2.35.1"
sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Reload group membership for ec2-user
newgrp docker <<EONG
export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3

echo $DOCKER_PWD | docker login -u $DOCKER_USER --password-stdin
docker-compose -f docker-compose.yaml up --detach
EONG

echo "✅ Deployment complete"
