#!/usr/bin/env bash

set -e  # Exit on any error

# Step 1: Install Docker and Docker Compose
echo "🛠 Installing Docker and Docker Compose..."
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

DOCKER_COMPOSE_VERSION="v2.35.1"
sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Step 2: Wait briefly for Docker to stabilize
sleep 5

# Step 3: Set environment variables
export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3

echo "📦 Using image: $IMAGE"
echo "🔐 Logging in to DockerHub..."

# Step 4: DockerHub login and container deployment
echo "$DOCKER_PWD" | docker login -u "$DOCKER_USER" --password-stdin
docker-compose -f docker-compose.yaml up --detach

echo "✅ Deployment complete"
